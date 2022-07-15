# Contributing to Scrapbook

Thank you for wanting to contribute! I really appreciate that you use Scrapbook, and that
you care enough about it that you want to make it better. Please read the guidelines below
before submitting a bug report or working on a new feature or requesting a new feature. They
are guidelines, not hard-and-fast rules, and they will evolve and change as I learn more and
as this project and the people working on it change.

## Code of Conduct

The most importanat part of these guidelines is the [Code of Conduct](CODE_OF_CONDUCT.md).
It is expected that contributors will be respectful and won't be unkind to each other, and
the Code of Conduct lays that out along with how to report violations and what steps will be
taken to enforce the policy.

## Bug Reports

If you are unsure if a behavior is intended or a bug, feel free to create [a discussion]
[Discussion] with your question. If you are fairly sure you have encountered a bug, use [the
respository's issues tracker][Issues] to create a bug report. The issue should be tagged as
a bug, and the report should include the following:

- Clear steps to reproduce the issue
- A clear description of the behavior that you are seeing when you follow those steps
- A clear description of the behavior that you expected to see instead

## Feature Requests

If you have some thoughts about new features, please bring them up in [the repository's idea
discussion area][Discussion - Idea] to get feedback and shape them. Once you have a fully
thought-out and shaped plan for a new feature, you can open a feature request issue. A
feature request should have a clear description of what the feature is and what problem the
feature will solve or what capability the feature will enable. Be sure to tag the issue as a
feature request.

## Pull Requests

Please only open up pull requests that fall into one of the categories below. In particular,
please don't open up PRs that are simply cosmetic changes — changes that don't change or
add any functionality. I do prefer the code to be aesthetically pleasing and consistent, but
right now I don't have the time to review those changes.

### New features

This project is young enough that you shouldn't open a PR with a new feature without first
creating a [feature request](#feature-requests) issue first. I have thoughts on new features
and the direction I want Scrapbook to go, and I don't want you wasting your time if your new
feature won't align with that plan. So open a feature request and get some feedback from me
before working on that new feature.

### Bug fixes

Bug fixes are always welcome. If you are unsure if behavior you are seeing is a bug or not,
please first open a [bug report](#bug-reports) and get confirmation before working on a fix.
All bug fixes should include a test that would fail without the changes made to fix it.

## Conventions

Please follow the conventions you see in the code. We also have configured Rubocop with the
styleguide we want to use. Note that the current configuration is based on when I have done
something that violates the defaults and have decided that I prefer a different setting, so
there will be future changes when I hit more things. Also, you should try and adhere to the
Rubocop style guides as much as possible, but feel free to use your judgement and disable a
a guide for better legibility or to make the code clearer. If a maintainer disagrees with
your judgement, please follow their direction to follow the guideline.

If you are updating a Markdown file, such as this one, please hard-wrap your paragraphs at
92 characters.

Steps for creating good issues or pull requests.
Links to external documentation, mailing lists, or a code of conduct.
Community and behavioral expectations.


[Discussion]: https://github.com/bfad/scrapbook/discussions
[Discussion - Idea]: (https://github.com/bfad/scrapbook/discussions/categories/ideas)
[Issues]: https://github.com/bfad/scrapbook/issues
