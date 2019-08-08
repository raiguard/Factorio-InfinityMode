![](resources/preview.png)

Inspired by the antiquated Creative Mode mod, Infinity Mode grants access to various items and cheats to make testing easier. Generate or destroy infinite items and fluids, use energy-free and hyperquick versions of many vanilla entities, modify personal, force, surface, and game settings, and more!

Users of the Creative Mode mod will note vastly improved performance, streamlined tools, and additional features in comparison.

## Installation / Updates
You can download and update Infinity Mode through Factorio's in-game mod portal. Just search `Infinity Mode` and it should be there! You can also grab the ZIP file from the releases page of this repository, if desired.

## Code of Conduct
### Issues
Please use the issues section of this repository to ask questions, report bugs, or request features! However, please search to be sure that your question/bug/request hasn't already been made, so we can avoid having to close duplicates.

### Pull Requests
Pull Requests are welcome! If there is something you would like to see added, changed, or fixed, don't hesitate to try it yourself! There will be a certain code quality expected, and changes might be made to your contribution before merging, but all contributions are still very much appreciated!

## API
For Factorio mod developers, Infinity Mode is planned to include a comprehensive set of remote interfaces that you can use to listen for or invoke events within Infinity Mode. For a list of these interfaces and how to use them, please go [here](API.md)

## History
I have over 1000 hours in Factorio. Over that time, I have spent a lot of time using Creative Mode to test my setups. From the first time I used it, I noticed that it has a rather large performance overhead. Figuring that that was just a side effect of what it was doing, I continued to use it.

Fast forward to Spring 2019, I make my first mod, [Tapeline](https://github.com/raiguard/Tapeline). I go back to playing Factorio and end up using Creative Mode again. Now that I have some familiarity with the API, I realize that Creative Mode _was_ working with a limited API, but that it hadn't been properly updated since 0.15!

Thus, I set out to replace it. Many, _many_ new API features have been introduced since Creative Mode was released, and I was able to harness them to create a mod that has almost 1:1 feature parity, with consolidated tools, much better performance, and additional features to boot!