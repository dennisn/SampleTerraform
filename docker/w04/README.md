# Week 04: Collections, for_each, and Reusable Docker Components
This week moves from individually declared resources to data-driven infrastructure. By the end of Week 4, you should be able to:

- Model configuration using `list`, `set`, `map`, and `object`
- Create multiple resources with `count` and `for_each`
- Explain why `for_each` usually gives more stable resource addresses
- Transform collections using `for` expressions
- Access individual resource instances
- Refactor repeated Docker resources into a local module

## Knowledge check

### Set 1
1. What is the difference between `count.index` and `each.key`?
2. Why can inserting an item at the beginning of a list be dangerous when using count?
3. What resource address is created for the frontend container?
4. What type of value does for_each accept?
5. Why is a map often preferable to a list for named infrastructure components?
6. What happens if a for_each key changes from frontend to public?
7. How would you preserve the resource during that key change?
8. What is the difference between this:
```hcl
for_each = var.web_containers
```
and this:
```hcl
for_each = toset(var.container_names)
```

==> 
1. `count.index` is numeric only, starting from 0. `each.key` is string, and return each of the key
2. With `count`, resource id is often tied to the index. By inserting item at the start, the resource being shifted by one, creating mismatch ==> terraform would destroy existing resources and re-create them with new index
3. `docker_container.web["frontend"]`
4. `map()` or `toset(string)` --> list or tuple must be put into `toset(...)`
5. as you can use the human-readable key as name, and map to multiple values
6. the resource will be re-created
7. using `moved` block
8. The first iterates over a map and exposes distinct keys and values. The second converts a list-like value into a set of strings, where each.key and each.value are the same string.