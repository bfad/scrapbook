# Changelog

This file tracks the notable changes made to this project. It is meant for humans to read,
and is loosely based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/). The
version numbers generally follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html),
even though I have reservations about what constitutes breaking changes. (What a maintainer
may consider to be a bug might be behavior a consumer relies upon in their project.)

## Unreleased

### Fixed

- Documentation typos and markup issues

[Unreleased commits](https://github.com/bfad/scrapbook/compare/v0.2.0...HEAD)

## 0.2.0 (2022-07-18)

Initial release of Scrapbook.

### Added

- Ability to create scrapbook folders. These folders allow for creating a hierarchy of Rails
  template files that can be processed as if they were part of your Rails application.

- A Rails engine that displays the hierarchy and the processed template web views through
  the web interface at the path you mount in your application's routes file.

[0.2.0 commits](https://github.com/bfad/scrapbook/releases/tag/v0.2.0)

