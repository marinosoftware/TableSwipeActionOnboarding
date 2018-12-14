# UITableViewCell onboarding animation
Animating a `UITableViewCell` to show the `editActions` isn't as straightforward as you would think. I couldn't find any public APIs to do this programatically (If you found them, please let me know). So I created a custom animation, to help users in the onboarding process. You can read more about TableSwipeActionOnboarding on [our blog](https://www.marinosoftware.com/insights/how-to-make-your-own-ios-swipe-onboarding-animation).

<img src="example.gif" alt="UITableViewCell swipe action example" width="150" />

## How to implement

Add the following code in `viewDidLayoutSubviews()` of the `ViewController` that has your `TableView` to ensure all constraints have been applied.

```
if !UserDefaults.standard.bool(forKey: TableViewCellOnboarding.userDefaultsFinishedKey) {
    let config = TableViewCellOnboarding.Config(initialDelay: 1, duration: 2.5, halfwayDelay: 0.5)
    onboardingCell = TableViewCellOnboarding(with: tableView, config: config)
    onboardingCell?.editActions = tableView(tableView, editActionsForRowAt: IndexPath(row: 0, section: 0))
}
```

You'll have to manually set the editActions in `TableViewCellOnboarding` by using the `UITableViewDelegate`'s `tableView(_:editActionsForRowAt:)`. This is so our TableViewCellOnboarding can use the style of the actual editActions.

**And that's all there is to it**

## Config
To make the animation a bit more easily configurable you can pass in a `TableViewCellOnboarding.Config`. 

- `initialDelay`: How long the animation waits before playing
- `duration`: The total duration for the animation, back and forth. Including the halfwayDelay.
- `halfwayDelay`: How long the animation waits before moving back.

To use the default values you can just omit the `config` parameter.

## How to use
You can, of course, call the animation code whenever we like, but we'll need to make sure our `TableView` has been completely laid out.

Once the animation has finished *completely* `TableViewCellOnboarding.userDefaultsFinishedKey` is set to `true` so we can choose to show the animation only once.

If the user navigates away from the screen before the animation is finished `TableViewCellOnboarding.userDefaultsFinishedKey` will *not* be set to `true`. 
