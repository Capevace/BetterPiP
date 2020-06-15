<p align="center"><img alt="halbert logo" src="logo.png" style="max-width: 10rem;"></p>
<h1 align="center">BetterPiP</h1>
<h4 align="center">
  Native macOS picture-in-picture in Firefox and Chrome
</h4>

## Project archived
Due to Firefox and Chrome now having their own picture-in-picture solutions, I've decided to archive this repo. Might still be helpful for learning how to utilize macOS PIP.framework.

## Original README.md
While every major browser now supports some sort of picture-in-picture (PiP), back in the day that was not the case. Most PiP solutions out there were kinda wacky, since they were based on old browser extension APIs.

Then with OSX Yosemite, Apple implemented native picture-in-picture across macOS, with a solid Safari integration. This PiP implementation provided sleek UI and even moved with native notifications coming in. In short, this solution was probably the best on the market at that point.

**BetterPiP** enables the same native picture in picture framework _in Firefox and Google Chrome_ that Safari uses internally. This is based on Stephen Radford's [PiPHack](https://github.com/steve228uk/PiPHack).

## Features

- Watch HTML5 videos (YouTube, Vimeo, etc...) in native picture-in-picture mode (same as Safari)
- Watch any public url in picture in picture mode

## Build

You will need to build the project on your own since I don't currently own a Apple Developer License.
