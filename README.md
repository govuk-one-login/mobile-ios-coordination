# Coordination

Advanced implementation of the Coordinator pattern.

## Installation

To use Coordination in a SwiftPM project:

1. Add the following line to the dependencies in your `Package.swift` file:

```swift
.package(url: "https://github.com/alphagov/di-mobile-ios-coordination", from: "1.0.0"),
```

2. Add `Coordination` as a dependency for your target:

```swift
.target(name: "MyTarget", dependencies: [
  .product(name: "Coordination", package: "dcmaw-coordination"),
  "AnotherModule"
]),
```

3. Add `import Coordination` in your source code.

## Package description

Each self-contained flow within the application can conform to the `Coordinator` protocol.

### Children can be presented modally, as tabs or inline.

> Within Sources/Coordination/Flows exist the following protocols for enabling a view hierarchy of parents and children.
 
`AnyCoordinator` is usable within a hierarchy conforming to UIViewController to open a child modally.

`TabCoordinator` is usable within a tab bar hierarchy to open a child modally.

`NavigationCoordinator` is usable within a navigation hierarchy to open a child inline, it should also act as the navigation controller delegate.

### `ParentCoordinator` types can present `ChildCoordinator` types, when sub-flows are needed.

> Within Sources/Coordination exist the following protocols for enabling a coordinator to act as parents and/or children.

`Coordinator` is usable in a baseline coordinator implementation, including only a `start()` method. All other protocols in this package inherit from `Coordinator`

`ParentCoordinator` is usable to manage the relationship to a child, namely opening and finishing the child.

`ChildCoordinator` is usable to act as the child of a parent, namely calling the parent's `childDidFinish` method.

## Example Implementation

#### Implementing concrete Types conforming to the above protocols:

Using the Coordinator pattern through a navigation stack, conforming to `NavigationCoordinator` is appropriate. Also conforming to `ParentCoordinator` allows a child to be opened inline and assigns the `UINavigationControllerDelegate`. Conforming to `ChildCoordinator` allows finishing the child which calls the `didRegainFocus(fromChild child: ChildCoordinator?)`

```swift
class PrimaryCoordinator: NavigationCoordinator, ParentCoordinator {
    let root: UINavigationController
    var childCoordinators: [ChildCoordinator] = []
    
    override func didRegainFocus(fromChild child: ChildCoordinator?) {
        // Perform any operations after the parent regains focus
    }
}

class SecondaryCoordinator: NavigationCoordinator, ChildCoordinator {
    let root: UINavigationController
    weak var parentCoordinator: ParentCoordinator?
}
```

Using the Coordinator pattern through a navigation stack but needing a child coordinator whose child view controllers can be presented modally on a parent coordinator, conforming to `AnyCoordinator` is appropriate. Also conforming to `ParentCoordinator` allows a child to be opened modally. Conforming to `ChildCoordinator` allows finishing the child which calls the `didRegainFocus(fromChild child: ChildCoordinator?)`

```swift
class PrimaryCoordinator: AnyCoordinator, ParentCoordinator {
    let root: UIViewController
    var childCoordinators: [ChildCoordinator] = []
    
    override func didRegainFocus(fromChild child: ChildCoordinator?) {
        // Perform any operations after the parent regains focus
    }
}

class SecondaryCoordinator: AnyCoordinator, ChildCoordinator {
    let root: UIViewController
    weak var parentCoordinator: ParentCoordinator?
}
```

Using the Coordinator pattern in a tab bar navigation, conforming to `TabCoordinator` is appropriate. Also conforming to `ParentCoordinator` allows a child to be opened as a tab. Conforming to `ChildCoordinator` allows finishing the child which calls the `didRegainFocus(fromChild child: ChildCoordinator?)`

```swift
class PrimaryCoordinator: TabCoorinator, ParentCoordinator {
    let root: UITabBarController
    var childCoordinators: [ChildCoordinator] = []
    
    override func didRegainFocus(fromChild child: ChildCoordinator?) {
        // Perform any operations after the parent regains focus
    }
}

class SecondaryCoordinator: AnyCoordinator, ChildCoordinator {
    let root: UIViewController
    weak var parentCoordinator: ParentCoordinator?
}
```

#### Example of using the Coordinator pattern with the above Types:

When creating the parent conforming to `NavigationCoordinator`, calling the `openChildInline()` method to create and start the child

```swift
let parentCoordinator = PrimaryCoordinator(root: UINavigationController())
let childCoordinator = SecondaryCoordinator(root: root)
firstCoordinator.openChildInline(childCoordinator)
```

When creating the parent conforming to `AnyCoordinator`, calling the `openChildModally()` method to create and start the child

```swift
let parentCoordinator = PrimaryCoordinator(root: UINavigationController())
let childCoordinator = SecondaryCoordinator(root: UIViewController())
firstCoordinator.openChildModally(childCoordinator)
```

When creating the parent conforming to `TabCoordinator`, calling the `addTab()` method to create and start the child

```swift
let parentCoordinator = PrimaryCoordinator(root: UINavigationController())
let childCoordinator = SecondaryCoordinator(root: UIViewController())
firstCoordinator.addTab(childCoordinator)
```

Once the child has finished, using the `finish()` method to restore focus to the parent

```swift
childCoordinator.finish()
```

The parent's `didRegainFocus(fromChild child: ChildCoordinator?)` method will be called to shift the application focus from the child back to the parent.

If your parent contains multiple children, you can switch on the child to perfrom any context-specific operations.

```swift
extension PrimaryCoordinator {
    func didRegainFocus(fromChild child: ChildCoordinator?) {
        switch child {
        case let child as SecondaryCoordinator:
        ...
        case let child as TertiaryCoordinator:
        ...
        default: break
    }
}
```
