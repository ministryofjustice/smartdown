# Smartdown [![Build Status](https://travis-ci.org/alphagov/smartdown.svg?branch=master)](https://travis-ci.org/alphagov/smartdown)

Smartdown is a [custom formatting language](http://www.martinfowler.com/bliki/DomainSpecificLanguage.html) designed to generate HTML formatted questions. These questions can then be joined in a manner that articulates a full user journey.

Implementation details for each kind of question can be found in the [documentation directory](doc).

For example:


```markdown
  # A Formatting and Logic Language

  Smartdown helps GOV.UK users find the information they need without
  having to search through daunting official documentation.

  ## Some extra information you need to know before you start

  * Like bullet points
  * Can be used
  * Throughout this journey

  [start: step_1]

  ## Additional context after a start button

  Any more information down here
```

Will produce:

```html
<div id="js-replaceable">

  <header class="page-header group">
    <div>
      <h1>
        A formatting and Logic Language
      </h1>
    </div>
  </header>

  <div class="article-container group">
    <article role="article" class="group">
      <div class="inner">
        <div class="intro">
          <p>Smartdown helps GOV.UK users find the information they need
          without having to search through daunting official
          documentation.</p>

          <h2 id="some-extra-information-you-need-to-know-before-you-start">
            Some extra information you need to know before you start
          </h2>

          <ul>
            <li>Like bullet points</li>
            <li>Can be used</li>
            <li>Throughout this journey</li>
          </ul>

          <p class="get-started">
            <a rel="nofollow" href="/step-1/y" class="big button">
              Start now
            </a>
          </p>
        </div>

        <h2 id="additional-context-after-a-start-button">
          Additional context after a start button
        </h2>
        <p>Any more information down here</p>

      </div>
    </article>
  </div>

</div>
```

Which on GOV.UK will look like:

![](http://cl.ly/image/1V3e042P0s0h/Screen%20Shot%202014-12-03%20at%2017.50.55.png)


The language is designed to look like [Markdown](http://daringfireball.net/projects/markdown/), but it has been extended to allow you to write in logic rules, questions and conditional blocks of text.

## Overview

A single smartdown flow has a [Start Page](doc/start-pages.md), a set of [Questions](doc/questions.md),
[Outcomes](doc/outcomes.md) and a set of [Test Scenarios](doc/scenarios.md).

Start Pages, Questions and Outcomes are all a type of 'node'.
A node represents a single user interaction (normally a web page, but in other media may be presented differently).

Each question and outcome is held in its own file. The name of the files are significant: they are used to identify each question.


Here's an example of the check-uk-visa flow:

```
-- check-uk-visa
   |-- outcomes
   |   |-- general_y.txt
   |   |-- joining_family_m.txt
   |   |-- joining_family_y.txt
   |   |-- marriage.txt
   |   |-- medical_n.txt
   |   |-- medical_y.txt
   |   `-- ...
   |-- scenarios
   |   |-- 1.txt
   |   |-- 2.txt
   |   `-- 3.txt
   |-- questions
   |   |-- planning_to_leave_airport.txt
   |   |-- purpose_of_visit.txt
   |   |-- staying_for_how_long.txt
   |   |-- what_passport_do_you_have.txt
   `-- check-uk-visa.txt
```

## Wiki

Additional documentation and a [glossary of terms](https://github.com/alphagov/smartdown/wiki/Glossary) and concepts can be found in the [project wiki](https://github.com/alphagov/smartdown/wiki/) or in the [documentation folder](doc)

### Dependencies

Currently smartdown relies on the [Smart Answers](https://github.com/alphagov/smart-answers/) application to run.

### Running

For GOV.UK developers you can `bowl smartanswers` and navigate to an example flow such as http://smartanswers.dev.gov.uk/animal-example-multiple from within the GOV.UK VM.
