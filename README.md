# RegexRs

Rust's [regex](https://crates.io/crates/regex) library as an Elixir NIF.

This library is mostly an experiment.
However, it is usable, and all public functions should have tests and documentation,
so feel free to use it in accordance with the [LICENSE](LICENSE), but caveat emptor.

## motivation/tl;dr

Rust has an amazing [regex](https://crates.io/crates/regex) library.
I wanted to see how it compares to Elixir/Erlang's existing `Regex`/`re` library.

Though more investigation and benchmarking is needed, my takeaways so far:

- Rust is faster for most things, sometimes significantly, sometimes not
- Rust is consistently _much_ faster (10x, 20x, or more) when the regex does not match the haystack
- The variance between the median time and the 99%ile time is tighter with Rust

So, if a general speed increase, a consistent major speedup when the match is not found,
or 99%ile worst-case latencies matter to you, you may want to check out this library.
Otherwise, you should probably stick with the builtin `Regex`/`re` libraries,
as they are very good in their own right.

## Installation

```elixir
def deps do
  [
    {:regex_rs, git: "https://github.com/ckampfe/regex_rs.git"}
  ]
end
```

You will also need to have an existing Rust/Cargo installation,
which you can get [here.](https://www.rust-lang.org/tools/install)

## Todo

- [ ] Two separate modules: one for regular schedulers one for dirty schedulers
- [ ] Better tests
- [ ] More Rust regex API coverage
- [ ] Does it make sense to try to match Elixir API?
- [ ] Hex?
- [ ] Clean up test duplication
- [x] Examples

## Benchmarks

```
clark@doomguy:~/code/personal/regex_rs$ MIX_ENV=bench mix run bench.exs
Compiling NIF crate :regexrust (native/regexrust)...
    Finished release [optimized] target(s) in 0.00s
Operating System: Linux
CPU Information: AMD Ryzen 7 5800X 8-Core Processor
Number of Available Cores: 16
Available memory: 50.17 GB
Elixir 1.11.2
Erlang 23.2

Benchmark suite executing with the following configuration:
warmup: 2 s
time: 5 s
memory time: 0 ns
parallel: 1
inputs: big hit, big miss, small hit, small miss
Estimated total run time: 7.93 min

Benchmarking elixir match?/2 with input big hit...
Benchmarking elixir match?/2 with input big miss...
Benchmarking elixir match?/2 with input small hit...
Benchmarking elixir match?/2 with input small miss...
Benchmarking elixir named_captures/2 with input big hit...
Benchmarking elixir named_captures/2 with input big miss...
Benchmarking elixir named_captures/2 with input small hit...
Benchmarking elixir named_captures/2 with input small miss...
Benchmarking elixir replace/4 all with input big hit...
Benchmarking elixir replace/4 all with input big miss...
Benchmarking elixir replace/4 all with input small hit...
Benchmarking elixir replace/4 all with input small miss...
Benchmarking elixir replace/4 first match with input big hit...
Benchmarking elixir replace/4 first match with input big miss...
Benchmarking elixir replace/4 first match with input small hit...
Benchmarking elixir replace/4 first match with input small miss...
Benchmarking elixir run/2 with input big hit...
Benchmarking elixir run/2 with input big miss...
Benchmarking elixir run/2 with input small hit...
Benchmarking elixir run/2 with input small miss...
Benchmarking elixir scan/2 with input big hit...
Benchmarking elixir scan/2 with input big miss...
Benchmarking elixir scan/2 with input small hit...
Benchmarking elixir scan/2 with input small miss...
Benchmarking rust captures/2 with input big hit...
Benchmarking rust captures/2 with input big miss...
Benchmarking rust captures/2 with input small hit...
Benchmarking rust captures/2 with input small miss...
Benchmarking rust captures_iter/2 with input big hit...
Benchmarking rust captures_iter/2 with input big miss...
Benchmarking rust captures_iter/2 with input small hit...
Benchmarking rust captures_iter/2 with input small miss...
Benchmarking rust captures_iter_named/2 with input big hit...
Benchmarking rust captures_iter_named/2 with input big miss...
Benchmarking rust captures_iter_named/2 with input small hit...
Benchmarking rust captures_iter_named/2 with input small miss...
Benchmarking rust captures_named/2 with input big hit...
Benchmarking rust captures_named/2 with input big miss...
Benchmarking rust captures_named/2 with input small hit...
Benchmarking rust captures_named/2 with input small miss...
Benchmarking rust find/2 with input big hit...
Benchmarking rust find/2 with input big miss...
Benchmarking rust find/2 with input small hit...
Benchmarking rust find/2 with input small miss...
Benchmarking rust find_iter/2 with input big hit...
Benchmarking rust find_iter/2 with input big miss...
Benchmarking rust find_iter/2 with input small hit...
Benchmarking rust find_iter/2 with input small miss...
Benchmarking rust is_match/2 with input big hit...
Benchmarking rust is_match/2 with input big miss...
Benchmarking rust is_match/2 with input small hit...
Benchmarking rust is_match/2 with input small miss...
Benchmarking rust replace/3 named with input big hit...
Benchmarking rust replace/3 named with input big miss...
Benchmarking rust replace/3 named with input small hit...
Benchmarking rust replace/3 named with input small miss...
Benchmarking rust replace/3 numbered with input big hit...
Benchmarking rust replace/3 numbered with input big miss...
Benchmarking rust replace/3 numbered with input small hit...
Benchmarking rust replace/3 numbered with input small miss...
Benchmarking rust replace_all/3 named with input big hit...
Benchmarking rust replace_all/3 named with input big miss...
Benchmarking rust replace_all/3 named with input small hit...
Benchmarking rust replace_all/3 named with input small miss...
Benchmarking rust replace_all/3 numbered with input big hit...
Benchmarking rust replace_all/3 numbered with input big miss...
Benchmarking rust replace_all/3 numbered with input small hit...
Benchmarking rust replace_all/3 numbered with input small miss...

##### With input big hit #####
Name                                   ips        average  deviation         median         99th %
rust is_match/2                  3029.36 K        0.33 μs  ±1322.81%        0.30 μs        0.40 μs
rust find/2                      2092.51 K        0.48 μs  ±3436.67%        0.40 μs        0.70 μs
rust captures/2                  1038.90 K        0.96 μs  ±1545.23%        0.90 μs        1.20 μs
rust captures_named/2            1023.27 K        0.98 μs  ±1795.82%        0.90 μs        1.20 μs
elixir match?/2                   985.92 K        1.01 μs  ±1466.44%        0.90 μs        1.70 μs
elixir run/2                      863.43 K        1.16 μs  ±1271.26%           1 μs        2.20 μs
elixir named_captures/2           612.18 K        1.63 μs   ±804.69%        1.50 μs        2.80 μs
rust replace/3 numbered           482.76 K        2.07 μs   ±854.31%        1.90 μs        3.50 μs
elixir replace/4 first match      466.04 K        2.15 μs   ±534.89%        1.90 μs        5.40 μs
rust replace/3 named              464.20 K        2.15 μs   ±913.21%           2 μs        3.70 μs
rust find_iter/2                    4.29 K      232.84 μs    ±32.00%         173 μs      371.20 μs
rust replace_all/3 numbered         1.13 K      883.65 μs     ±1.48%      882.10 μs      905.55 μs
rust replace_all/3 named            1.02 K      978.53 μs     ±2.36%      976.10 μs     1003.70 μs
rust captures_iter/2                0.85 K     1174.95 μs    ±22.47%     1148.80 μs     1616.30 μs
rust captures_iter_named/2          0.83 K     1209.08 μs    ±12.37%     1241.20 μs     1518.63 μs
elixir scan/2                       0.51 K     1967.05 μs     ±1.63%     1960.10 μs     2053.59 μs
elixir replace/4 all                0.41 K     2454.99 μs     ±1.80%     2439.25 μs     2626.15 μs

Comparison:
rust is_match/2                  3029.36 K
rust find/2                      2092.51 K - 1.45x slower +0.148 μs
rust captures/2                  1038.90 K - 2.92x slower +0.63 μs
rust captures_named/2            1023.27 K - 2.96x slower +0.65 μs
elixir match?/2                   985.92 K - 3.07x slower +0.68 μs
elixir run/2                      863.43 K - 3.51x slower +0.83 μs
elixir named_captures/2           612.18 K - 4.95x slower +1.30 μs
rust replace/3 numbered           482.76 K - 6.28x slower +1.74 μs
elixir replace/4 first match      466.04 K - 6.50x slower +1.82 μs
rust replace/3 named              464.20 K - 6.53x slower +1.82 μs
rust find_iter/2                    4.29 K - 705.36x slower +232.51 μs
rust replace_all/3 numbered         1.13 K - 2676.89x slower +883.32 μs
rust replace_all/3 named            1.02 K - 2964.31x slower +978.20 μs
rust captures_iter/2                0.85 K - 3559.34x slower +1174.62 μs
rust captures_iter_named/2          0.83 K - 3662.73x slower +1208.75 μs
elixir scan/2                       0.51 K - 5958.90x slower +1966.72 μs
elixir replace/4 all                0.41 K - 7437.04x slower +2454.66 μs

##### With input big miss #####
Name                                   ips        average  deviation         median         99th %
rust is_match/2                    51.07 K       19.58 μs     ±4.52%       19.40 μs          23 μs
rust find/2                        50.86 K       19.66 μs   ±193.47%       19.40 μs       23.10 μs
rust find_iter/2                   50.48 K       19.81 μs     ±5.73%       19.80 μs       23.70 μs
rust replace_all/3 numbered        49.36 K       20.26 μs    ±20.40%       19.80 μs       24.90 μs
rust captures_named/2              49.08 K       20.37 μs     ±4.77%       20.20 μs          24 μs
rust captures_iter/2               48.84 K       20.48 μs     ±4.90%       20.20 μs       24.10 μs
rust captures/2                    48.81 K       20.49 μs     ±5.66%       20.20 μs       24.10 μs
rust captures_iter_named/2         48.69 K       20.54 μs     ±5.12%       20.20 μs       24.30 μs
rust replace_all/3 named           48.05 K       20.81 μs    ±17.79%       20.60 μs       25.10 μs
rust replace/3 numbered            47.81 K       20.92 μs    ±12.55%       20.50 μs          25 μs
rust replace/3 named               47.69 K       20.97 μs    ±83.39%       20.60 μs       25.10 μs
elixir named_captures/2             3.05 K      328.37 μs     ±2.31%      326.60 μs      358.41 μs
elixir scan/2                       2.03 K      493.10 μs     ±6.71%      514.80 μs         535 μs
elixir match?/2                     2.02 K      495.10 μs    ±45.25%      513.30 μs      536.66 μs
elixir run/2                        1.99 K      502.70 μs     ±6.51%      522.10 μs      542.40 μs
elixir replace/4 all                1.63 K      615.28 μs     ±4.64%      611.50 μs      684.99 μs
elixir replace/4 first match        1.62 K      618.54 μs     ±4.89%      612.70 μs      689.53 μs

Comparison:
rust is_match/2                    51.07 K
rust find/2                        50.86 K - 1.00x slower +0.0806 μs
rust find_iter/2                   50.48 K - 1.01x slower +0.23 μs
rust replace_all/3 numbered        49.36 K - 1.03x slower +0.68 μs
rust captures_named/2              49.08 K - 1.04x slower +0.79 μs
rust captures_iter/2               48.84 K - 1.05x slower +0.90 μs
rust captures/2                    48.81 K - 1.05x slower +0.91 μs
rust captures_iter_named/2         48.69 K - 1.05x slower +0.96 μs
rust replace_all/3 named           48.05 K - 1.06x slower +1.23 μs
rust replace/3 numbered            47.81 K - 1.07x slower +1.34 μs
rust replace/3 named               47.69 K - 1.07x slower +1.39 μs
elixir named_captures/2             3.05 K - 16.77x slower +308.79 μs
elixir scan/2                       2.03 K - 25.18x slower +473.52 μs
elixir match?/2                     2.02 K - 25.28x slower +475.52 μs
elixir run/2                        1.99 K - 25.67x slower +483.12 μs
elixir replace/4 all                1.63 K - 31.42x slower +595.70 μs
elixir replace/4 first match        1.62 K - 31.59x slower +598.96 μs

##### With input small hit #####
Name                                   ips        average  deviation         median         99th %
rust is_match/2                    11.71 M       85.40 ns   ±165.64%         100 ns         100 ns
rust find/2                         3.82 M      261.90 ns  ±3079.13%         200 ns         600 ns
rust find_iter/2                    1.93 M      518.53 ns  ±4644.21%         400 ns         800 ns
rust captures/2                     1.72 M      581.51 ns  ±2957.61%         500 ns         900 ns
rust captures_named/2               1.60 M      624.63 ns  ±2859.90%         500 ns         900 ns
rust replace/3 numbered             1.26 M      796.21 ns  ±1359.49%         800 ns        1100 ns
rust replace/3 named                1.21 M      827.90 ns  ±1317.90%         800 ns        1100 ns
rust replace_all/3 numbered         1.15 M      871.05 ns  ±1189.45%         800 ns        1200 ns
rust replace_all/3 named            1.03 M      973.22 ns  ±1115.19%         900 ns        1400 ns
elixir match?/2                     0.94 M     1061.88 ns  ±1516.91%        1000 ns        1100 ns
rust captures_iter/2                0.86 M     1164.51 ns  ±1574.91%        1000 ns        1500 ns
elixir run/2                        0.82 M     1219.55 ns  ±1141.04%        1100 ns        1500 ns
rust captures_iter_named/2          0.77 M     1293.11 ns  ±1329.19%        1100 ns        1700 ns
elixir named_captures/2             0.58 M     1727.42 ns   ±771.23%        1600 ns        3100 ns
elixir replace/4 first match        0.56 M     1799.72 ns   ±628.61%        1600 ns        3700 ns
elixir scan/2                       0.30 M     3352.83 ns   ±332.05%        3000 ns        9600 ns
elixir replace/4 all                0.24 M     4181.01 ns   ±261.94%        3800 ns       10200 ns

Comparison:
rust is_match/2                    11.71 M
rust find/2                         3.82 M - 3.07x slower +176.50 ns
rust find_iter/2                    1.93 M - 6.07x slower +433.13 ns
rust captures/2                     1.72 M - 6.81x slower +496.12 ns
rust captures_named/2               1.60 M - 7.31x slower +539.23 ns
rust replace/3 numbered             1.26 M - 9.32x slower +710.81 ns
rust replace/3 named                1.21 M - 9.69x slower +742.51 ns
rust replace_all/3 numbered         1.15 M - 10.20x slower +785.65 ns
rust replace_all/3 named            1.03 M - 11.40x slower +887.82 ns
elixir match?/2                     0.94 M - 12.43x slower +976.48 ns
rust captures_iter/2                0.86 M - 13.64x slower +1079.11 ns
elixir run/2                        0.82 M - 14.28x slower +1134.15 ns
rust captures_iter_named/2          0.77 M - 15.14x slower +1207.71 ns
elixir named_captures/2             0.58 M - 20.23x slower +1642.02 ns
elixir replace/4 first match        0.56 M - 21.07x slower +1714.32 ns
elixir scan/2                       0.30 M - 39.26x slower +3267.43 ns
elixir replace/4 all                0.24 M - 48.96x slower +4095.61 ns

##### With input small miss #####
Name                                   ips        average  deviation         median         99th %
rust is_match/2                     9.98 M      100.24 ns   ±204.12%         100 ns         200 ns
rust find/2                         9.49 M      105.38 ns   ±202.28%         100 ns         200 ns
rust find_iter/2                    8.08 M      123.69 ns   ±125.38%         100 ns         200 ns
rust captures_iter/2                7.58 M      132.00 ns   ±136.26%         100 ns         200 ns
rust captures/2                     7.56 M      132.23 ns   ±119.94%         100 ns         200 ns
rust captures_iter_named/2          7.52 M      133.06 ns   ±198.45%         100 ns         200 ns
rust captures_named/2               7.43 M      134.57 ns  ±2807.48%         100 ns         200 ns
rust replace_all/3 numbered         3.45 M      289.62 ns  ±6127.69%         200 ns         600 ns
rust replace_all/3 named            3.44 M      290.59 ns  ±6108.16%         200 ns         600 ns
rust replace/3 named                3.29 M      303.63 ns  ±6162.33%         300 ns         700 ns
rust replace/3 numbered             3.15 M      317.11 ns  ±6515.47%         300 ns         700 ns
elixir match?/2                     0.77 M     1291.02 ns   ±756.20%        1300 ns        1400 ns
elixir run/2                        0.75 M     1332.98 ns   ±981.90%        1300 ns        1400 ns
elixir scan/2                       0.67 M     1495.97 ns   ±857.84%        1400 ns        1700 ns
elixir named_captures/2             0.55 M     1816.08 ns   ±782.63%        1700 ns        2900 ns
elixir replace/4 first match        0.51 M     1955.41 ns   ±723.37%        1800 ns        3400 ns
elixir replace/4 all                0.46 M     2163.73 ns   ±543.07%        2000 ns        4700 ns

Comparison:
rust is_match/2                     9.98 M
rust find/2                         9.49 M - 1.05x slower +5.14 ns
rust find_iter/2                    8.08 M - 1.23x slower +23.46 ns
rust captures_iter/2                7.58 M - 1.32x slower +31.76 ns
rust captures/2                     7.56 M - 1.32x slower +31.99 ns
rust captures_iter_named/2          7.52 M - 1.33x slower +32.82 ns
rust captures_named/2               7.43 M - 1.34x slower +34.33 ns
rust replace_all/3 numbered         3.45 M - 2.89x slower +189.38 ns
rust replace_all/3 named            3.44 M - 2.90x slower +190.35 ns
rust replace/3 named                3.29 M - 3.03x slower +203.39 ns
rust replace/3 numbered             3.15 M - 3.16x slower +216.87 ns
elixir match?/2                     0.77 M - 12.88x slower +1190.78 ns
elixir run/2                        0.75 M - 13.30x slower +1232.74 ns
elixir scan/2                       0.67 M - 14.92x slower +1395.74 ns
elixir named_captures/2             0.55 M - 18.12x slower +1715.84 ns
elixir replace/4 first match        0.51 M - 19.51x slower +1855.18 ns
elixir replace/4 all                0.46 M - 21.59x slower +2063.50 ns
```
