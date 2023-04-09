# riverpod_skip_loading_on_reload_issue
Exemples to describe an issue in the Riverpod repo

There are two folder with roughly the same code. But
* The old_behavior_exemple use Riverpod `v2.0.0-dev.0`
* The new_behavior_exemple use Riverpod `v2.3.4`

Those exemples aims to describe the problems with `skipLoadingOnReload` with two code samples:
* Reloading vs refreshing providers.
* Stream vs Future providers.