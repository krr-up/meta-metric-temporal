# meta-metric-temporal

Experiments in implementing metric temporal answer set programming
using meta-programming.

Some examples in the input language of our implementation are provided
under the `examples` directory. To run one such example, say
`traffic-light.lp`, run the following command:

```
clingo --output=reify examples/traffic-light.lp | clingo - meta.lp -c horizon=7 0
```

The appropriate command as well as the expected output are included at
the end of the example files as comments.
