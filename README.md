# RegexRs

Rust's [regex](https://crates.io/crates/regex) library as an Elixir NIF.

## Installation

```elixir
def deps do
  [
    {:regex_rs, git: "https://github.com/ckampfe/regex_rs.git"}
  ]
end
```

## Todo

- [ ] Two separate modules: one for regular schedulers one for dirty schedulers
- [ ] Better tests
- [ ] More Rust regex API coverage
- [ ] Does it make sense to try to match Elixir API?
- [ ] Hex?
- [x] Examples

## Benchmarks

```
$ MIX_ENV=bench mix run bench.exs
Compiling NIF crate :regexrust (native/regexrust)...
   Compiling regexrust v0.1.0 (/home/clark/code/personal/regex_rs/native/regexrust)
    Finished release [optimized] target(s) in 1.17s
Compiling 1 file (.ex)
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
Estimated total run time: 6.53 min

Benchmarking elixir match with input big hit...
Benchmarking elixir match with input big miss...
Benchmarking elixir match with input small hit...
Benchmarking elixir match with input small miss...
Benchmarking elixir named captures with input big hit...
Benchmarking elixir named captures with input big miss...
Benchmarking elixir named captures with input small hit...
Benchmarking elixir named captures with input small miss...
Benchmarking elixir replace with input big hit...
Benchmarking elixir replace with input big miss...
Benchmarking elixir replace with input small hit...
Benchmarking elixir replace with input small miss...
Benchmarking elixir replace all with input big hit...
Benchmarking elixir replace all with input big miss...
Benchmarking elixir replace all with input small hit...
Benchmarking elixir replace all with input small miss...
Benchmarking elixir run with input big hit...
Benchmarking elixir run with input big miss...
Benchmarking elixir run with input small hit...
Benchmarking elixir run with input small miss...
Benchmarking elixir scan with input big hit...
Benchmarking elixir scan with input big miss...
Benchmarking elixir scan with input small hit...
Benchmarking elixir scan with input small miss...
Benchmarking rust match with input big hit...
Benchmarking rust match with input big miss...
Benchmarking rust match with input small hit...
Benchmarking rust match with input small miss...
Benchmarking rust named captures with input big hit...
Benchmarking rust named captures with input big miss...
Benchmarking rust named captures with input small hit...
Benchmarking rust named captures with input small miss...
Benchmarking rust replace named with input big hit...
Benchmarking rust replace named with input big miss...
Benchmarking rust replace named with input small hit...
Benchmarking rust replace named with input small miss...
Benchmarking rust replace numbered with input big hit...
Benchmarking rust replace numbered with input big miss...
Benchmarking rust replace numbered with input small hit...
Benchmarking rust replace numbered with input small miss...
Benchmarking rust replace_all named with input big hit...
Benchmarking rust replace_all named with input big miss...
Benchmarking rust replace_all named with input small hit...
Benchmarking rust replace_all named with input small miss...
Benchmarking rust replace_all numbered with input big hit...
Benchmarking rust replace_all numbered with input big miss...
Benchmarking rust replace_all numbered with input small hit...
Benchmarking rust replace_all numbered with input small miss...
Benchmarking rust run with input big hit...
Benchmarking rust run with input big miss...
Benchmarking rust run with input small hit...
Benchmarking rust run with input small miss...
Benchmarking rust scan with input big hit...
Benchmarking rust scan with input big miss...
Benchmarking rust scan with input small hit...
Benchmarking rust scan with input small miss...

##### With input big hit #####
Name                                ips        average  deviation         median         99th %
rust match                    3513.48 K        0.28 μs    ±58.14%        0.30 μs        0.40 μs
rust named captures           1051.96 K        0.95 μs  ±1945.57%        0.80 μs        1.20 μs
elixir match                  1015.13 K        0.99 μs  ±1858.13%        0.90 μs        1.80 μs
rust run                       869.52 K        1.15 μs  ±1202.24%        1.10 μs        1.60 μs
elixir run                     866.63 K        1.15 μs  ±1122.05%           1 μs           2 μs
elixir named captures          613.07 K        1.63 μs   ±740.90%        1.50 μs        2.70 μs
rust replace numbered          495.33 K        2.02 μs   ±657.92%        1.90 μs        3.50 μs
rust replace named             489.54 K        2.04 μs   ±604.51%        1.90 μs        3.60 μs
elixir replace                 431.29 K        2.32 μs   ±500.12%           2 μs       12.20 μs
rust scan                        4.19 K      238.45 μs    ±95.06%      180.80 μs      369.60 μs
rust replace_all numbered        1.12 K      890.42 μs     ±1.41%      887.80 μs      914.30 μs
rust replace_all named           1.01 K      990.54 μs     ±4.48%      985.20 μs     1117.99 μs
elixir scan                      0.53 K     1903.75 μs     ±1.82%     1899.90 μs     1986.28 μs
elixir replace all               0.39 K     2560.51 μs     ±1.77%     2553.90 μs     2749.73 μs

Comparison:
rust match                    3513.48 K
rust named captures           1051.96 K - 3.34x slower +0.67 μs
elixir match                  1015.13 K - 3.46x slower +0.70 μs
rust run                       869.52 K - 4.04x slower +0.87 μs
elixir run                     866.63 K - 4.05x slower +0.87 μs
elixir named captures          613.07 K - 5.73x slower +1.35 μs
rust replace numbered          495.33 K - 7.09x slower +1.73 μs
rust replace named             489.54 K - 7.18x slower +1.76 μs
elixir replace                 431.29 K - 8.15x slower +2.03 μs
rust scan                        4.19 K - 837.78x slower +238.16 μs
rust replace_all numbered        1.12 K - 3128.46x slower +890.13 μs
rust replace_all named           1.01 K - 3480.23x slower +990.25 μs
elixir scan                      0.53 K - 6688.77x slower +1903.46 μs
elixir replace all               0.39 K - 8996.29x slower +2560.22 μs

##### With input big miss #####
Name                                ips        average  deviation         median         99th %
rust scan                       52.48 K       19.06 μs     ±4.82%       18.90 μs       22.60 μs
rust match                      50.97 K       19.62 μs   ±205.30%       19.40 μs          23 μs
rust named captures             48.52 K       20.61 μs     ±5.48%       20.30 μs       24.50 μs
rust run                        48.21 K       20.74 μs     ±5.93%       20.20 μs       24.60 μs
rust replace_all numbered       47.02 K       21.27 μs    ±20.65%       20.60 μs       27.10 μs
rust replace named              47.01 K       21.27 μs    ±10.89%       20.60 μs       26.50 μs
rust replace numbered           46.88 K       21.33 μs    ±81.11%       20.60 μs       26.40 μs
rust replace_all named          44.26 K       22.60 μs   ±668.81%       21.70 μs       28.90 μs
elixir named captures            3.01 K      331.71 μs     ±1.82%      330.80 μs      354.20 μs
elixir scan                      2.61 K      383.79 μs     ±1.99%      382.80 μs      430.70 μs
elixir match                     2.57 K      388.91 μs     ±1.79%      387.30 μs      416.05 μs
elixir run                       2.18 K      458.15 μs     ±1.52%      457.30 μs      477.31 μs
elixir replace                   1.61 K      620.62 μs     ±1.41%      619.40 μs      643.46 μs
elixir replace all               1.61 K      621.74 μs     ±1.12%      620.70 μs      642.70 μs

Comparison:
rust scan                       52.48 K
rust match                      50.97 K - 1.03x slower +0.56 μs
rust named captures             48.52 K - 1.08x slower +1.55 μs
rust run                        48.21 K - 1.09x slower +1.69 μs
rust replace_all numbered       47.02 K - 1.12x slower +2.21 μs
rust replace named              47.01 K - 1.12x slower +2.22 μs
rust replace numbered           46.88 K - 1.12x slower +2.27 μs
rust replace_all named          44.26 K - 1.19x slower +3.54 μs
elixir named captures            3.01 K - 17.41x slower +312.66 μs
elixir scan                      2.61 K - 20.14x slower +364.74 μs
elixir match                     2.57 K - 20.41x slower +369.85 μs
elixir run                       2.18 K - 24.04x slower +439.09 μs
elixir replace                   1.61 K - 32.57x slower +601.57 μs
elixir replace all               1.61 K - 32.63x slower +602.68 μs

##### With input small hit #####
Name                                ips        average  deviation         median         99th %
rust match                      15.78 M       63.38 ns   ±227.96%         100 ns         100 ns
rust scan                        2.03 M      492.01 ns  ±4279.72%         400 ns         800 ns
rust named captures              1.73 M      576.94 ns  ±3151.62%         500 ns         800 ns
rust run                         1.55 M      644.20 ns  ±3173.10%         600 ns        1000 ns
rust replace numbered            1.32 M      756.89 ns  ±1649.30%         700 ns        1100 ns
rust replace named               1.23 M      812.74 ns  ±1596.99%         800 ns        1100 ns
rust replace_all numbered        1.17 M      854.11 ns  ±1465.42%         800 ns        1100 ns
rust replace_all named           1.04 M      957.94 ns  ±1458.58%         900 ns        1400 ns
elixir match                     0.95 M     1047.50 ns  ±1798.43%         900 ns        1900 ns
elixir run                       0.81 M     1238.44 ns  ±1276.71%        1100 ns        2200 ns
elixir named captures            0.57 M     1740.28 ns   ±811.23%        1600 ns        3100 ns
elixir replace                   0.54 M     1850.56 ns   ±602.66%        1700 ns        4300 ns
elixir scan                      0.31 M     3227.97 ns   ±382.17%        3000 ns        6400 ns
elixir replace all               0.23 M     4287.06 ns   ±195.71%        3900 ns       10100 ns

Comparison:
rust match                      15.78 M
rust scan                        2.03 M - 7.76x slower +428.63 ns
rust named captures              1.73 M - 9.10x slower +513.55 ns
rust run                         1.55 M - 10.16x slower +580.82 ns
rust replace numbered            1.32 M - 11.94x slower +693.51 ns
rust replace named               1.23 M - 12.82x slower +749.36 ns
rust replace_all numbered        1.17 M - 13.48x slower +790.73 ns
rust replace_all named           1.04 M - 15.11x slower +894.56 ns
elixir match                     0.95 M - 16.53x slower +984.12 ns
elixir run                       0.81 M - 19.54x slower +1175.06 ns
elixir named captures            0.57 M - 27.46x slower +1676.90 ns
elixir replace                   0.54 M - 29.20x slower +1787.17 ns
elixir scan                      0.31 M - 50.93x slower +3164.59 ns
elixir replace all               0.23 M - 67.64x slower +4223.68 ns

##### With input small miss #####
Name                                ips        average  deviation         median         99th %
rust match                      13.07 M       76.52 ns   ±171.47%         100 ns         100 ns
rust scan                       10.16 M       98.46 ns   ±228.74%         100 ns         200 ns
rust run                         7.91 M      126.38 ns   ±117.64%         100 ns         200 ns
rust named captures              6.85 M      145.98 ns   ±523.44%         100 ns         500 ns
rust replace_all numbered        3.49 M      286.17 ns  ±5208.80%         300 ns         700 ns
rust replace numbered            3.46 M      288.93 ns  ±5139.46%         300 ns         700 ns
rust replace named               3.34 M      299.26 ns  ±7879.82%         300 ns         700 ns
rust replace_all named           3.33 M      300.64 ns  ±5334.15%         300 ns         700 ns
elixir run                       0.76 M     1312.22 ns  ±1149.47%        1300 ns        1400 ns
elixir match                     0.72 M     1392.72 ns  ±1011.88%        1300 ns        2300 ns
elixir scan                      0.59 M     1696.61 ns   ±874.94%        1500 ns        3000 ns
elixir named captures            0.55 M     1804.50 ns   ±618.15%        1700 ns        2800 ns
elixir replace                   0.50 M     1987.93 ns   ±685.79%        1800 ns        3300 ns
elixir replace all               0.45 M     2198.25 ns   ±494.43%        2000 ns        3900 ns

Comparison:
rust match                      13.07 M
rust scan                       10.16 M - 1.29x slower +21.94 ns
rust run                         7.91 M - 1.65x slower +49.87 ns
rust named captures              6.85 M - 1.91x slower +69.47 ns
rust replace_all numbered        3.49 M - 3.74x slower +209.65 ns
rust replace numbered            3.46 M - 3.78x slower +212.41 ns
rust replace named               3.34 M - 3.91x slower +222.74 ns
rust replace_all named           3.33 M - 3.93x slower +224.12 ns
elixir run                       0.76 M - 17.15x slower +1235.70 ns
elixir match                     0.72 M - 18.20x slower +1316.20 ns
elixir scan                      0.59 M - 22.17x slower +1620.10 ns
elixir named captures            0.55 M - 23.58x slower +1727.98 ns
elixir replace                   0.50 M - 25.98x slower +1911.41 ns
elixir replace all               0.45 M - 28.73x slower +2121.73 ns
```
