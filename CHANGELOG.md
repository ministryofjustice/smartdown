## 0.0.4

### Interpolation

Interpolate a variable from state into Govspeak text.

```
Your state pension age is %{state_pension_age}
```

These values currently come from previous question answers and is te exact value
rather than the human 'label' of the answer.

Once plugins/calculations are added they will support interpolation as well.

### Start button first node

Previously cover pages needed a single `* otherwise =>` next node rule to define
the first question. This can now be done as part of the start button definition.

```
[start_button: what_passport_do_you_have]
```

### Next steps

This is follow on content that appears distinct from the outcome itself, was not
modelled in Smartdown before:

```
[next_steps]
... Govspeak goes here ...
[end_next_steps]
```

### Question variable name definition

Previously this was inferred from the node/file name, now this _must_ be
specified by the question definition, which gives more flexibility and will help
support multiple questions per node.

```
[choice: uk_border_control]
```




## 0.0.3

* support for conditionals
* mandatory 'tag' on choice questions in the form:

```
[choice: question_name]
* opt1: Option one
* opt2: Option two
```