// This file contains 2mm using SDIR

module {
    sdir.sdfg{entry=@init, arg_names=["ni", "nj", "nk", "nl", "tmp", "A", "B", "C", "D", "alpha", "beta"]} @k2mm {
        sdir.alloc_symbol("i1")
        sdir.alloc_symbol("j1")
        sdir.alloc_symbol("k1")
        sdir.alloc_symbol("i2")
        sdir.alloc_symbol("j2")
        sdir.alloc_symbol("k2")

        %ni = sdir.alloc{name="ni"}() : !sdir.array<i64>
        %nj = sdir.alloc{name="nj"}() : !sdir.array<i64>
        %nk = sdir.alloc{name="nk"}() : !sdir.array<i64>
        %nl = sdir.alloc{name="nl"}() : !sdir.array<i64>

        %alpha = sdir.alloc{name="alpha"}() : !sdir.array<f64>
        %beta = sdir.alloc{name="beta"}() : !sdir.array<f64>

        %tmp = sdir.alloc{name="tmp"}() : !sdir.array<800x900xf64>
        %A = sdir.alloc{name="A"}() : !sdir.array<800x1100xf64>
        %B = sdir.alloc{name="B"}() : !sdir.array<1100x900xf64>
        %C = sdir.alloc{name="C"}() : !sdir.array<900x1200xf64>
        %D = sdir.alloc{name="D"}() : !sdir.array<800x1200xf64>

        sdir.state @init {}

        sdir.state @guard_18 {}

        sdir.state @guard_16 {}

        sdir.state @call_12 {
            sdir.tasklet{} @get_0() -> f64 {
                %0 = arith.constant 0.0 : f64
                sdir.return %0 : f64
            }

            %tmp_a = sdir.get_access %tmp : !sdir.array<800x900xf64> -> !sdir.memlet<800x900xf64>
            %0 = sdir.call @get_0() : () -> f64
            sdir.store %0, %tmp_a[sym("i1"), sym("j1")] : f64 -> !sdir.memlet<800x900xf64>
        }

        sdir.state @guard {}

        sdir.state @slice_tmp_14 {
            sdir.tasklet{} @multA(%a: f64, %b: f64) -> f64 {
                %c = arith.mulf %a, %b: f64
                sdir.return %c : f64
            }

            sdir.tasklet{} @multB(%a: f64, %b: f64) -> f64 {
                %c = arith.mulf %a, %b: f64
                sdir.return %c : f64
            }

            sdir.tasklet{} @add(%a: f64, %b: f64) -> f64 {
                %c = arith.addf %a, %b: f64
                sdir.return %c : f64
            }

            %tmp_r = sdir.get_access %tmp : !sdir.array<800x900xf64> -> !sdir.memlet<800x900xf64>
            %tmp_w = sdir.get_access %tmp : !sdir.array<800x900xf64> -> !sdir.memlet<800x900xf64>
            %A_a = sdir.get_access %A : !sdir.array<800x1100xf64> -> !sdir.memlet<800x1100xf64>
            %B_a = sdir.get_access %B : !sdir.array<1100x900xf64> -> !sdir.memlet<1100x900xf64>
            %alpha_a = sdir.get_access %alpha : !sdir.array<f64> -> !sdir.memlet<f64>
           
            %A_v = sdir.load %A_a[sym("i1"), sym("k1")] : !sdir.memlet<800x1100xf64> -> f64
            %alpha_v = sdir.load %alpha_a[] : !sdir.memlet<f64> -> f64
            %0 = sdir.call @multA(%alpha_v, %A_v) : (f64, f64) -> f64

            %B_v = sdir.load %B_a[sym("k1"), sym("j1")] : !sdir.memlet<1100x900xf64> -> f64
            %1 = sdir.call @multB(%0, %B_v) : (f64, f64) -> f64

            %tmp_v = sdir.load %tmp_r[sym("i1"), sym("j1")] : !sdir.memlet<800x900xf64> -> f64
            %2 = sdir.call @add(%tmp_v, %1) : (f64, f64) -> f64
            sdir.store %2, %tmp_w[sym("i1"), sym("j1")] : f64 -> !sdir.memlet<800x900xf64>
        }

        sdir.state @guard_36 {}

        sdir.state @endfor_16 {}

        sdir.state @guard_34 {}

        sdir.state @slice_D_18 {
            sdir.tasklet{} @mult(%a: f64, %b: f64) -> f64 {
                %c = arith.mulf %a, %b: f64
                sdir.return %c : f64
            }

            %D_r = sdir.get_access %D : !sdir.array<800x1200xf64> -> !sdir.memlet<800x1200xf64>
            %D_w = sdir.get_access %D : !sdir.array<800x1200xf64> -> !sdir.memlet<800x1200xf64>
            %beta_a = sdir.get_access %beta : !sdir.array<f64> -> !sdir.memlet<f64>

            %D_v = sdir.load %D_r[sym("i2"), sym("j2")] : !sdir.memlet<800x1200xf64> -> f64
            %beta_v = sdir.load %beta_a[] : !sdir.memlet<f64> -> f64

            %0 = sdir.call @mult(%D_v, %beta_v) : (f64, f64) -> f64
            sdir.store %0, %D_w[sym("i2"), sym("j2")] : f64 -> !sdir.memlet<800x1200xf64>
        }

        sdir.state @guard_32 {}

        sdir.state @slice_D_20 {
            sdir.tasklet{} @mult(%a: f64, %b: f64) -> f64 {
                %c = arith.mulf %a, %b: f64
                sdir.return %c : f64
            }

            sdir.tasklet{} @add(%a: f64, %b: f64) -> f64 {
                %c = arith.addf %a, %b: f64
                sdir.return %c : f64
            }

            %tmp_a = sdir.get_access %tmp : !sdir.array<800x900xf64> -> !sdir.memlet<800x900xf64>
            %C_a = sdir.get_access %C : !sdir.array<900x1200xf64> -> !sdir.memlet<900x1200xf64>
            %D_r = sdir.get_access %D : !sdir.array<800x1200xf64> -> !sdir.memlet<800x1200xf64>
            %D_w = sdir.get_access %D : !sdir.array<800x1200xf64> -> !sdir.memlet<800x1200xf64>

            %tmp_v = sdir.load %tmp_a[sym("i2"), sym("k2")] : !sdir.memlet<800x900xf64> -> f64
            %C_v = sdir.load %C_a[sym("k2"), sym("j2")] : !sdir.memlet<900x1200xf64> -> f64
            %D_v = sdir.load %D_r[sym("i2"), sym("j2")] : !sdir.memlet<800x1200xf64> -> f64

            %0 = sdir.call @mult(%tmp_v, %C_v) : (f64, f64) -> f64
            %1 = sdir.call @add(%D_v, %0) : (f64, f64) -> f64
            sdir.store %1, %D_w[sym("i2"), sym("j2")] : f64 -> !sdir.memlet<800x1200xf64>
        }

        sdir.edge{assign=["i1: 0"]} @init -> @guard_18
        sdir.edge{assign=["j1: 0"], condition="i1 < ni"} @guard_18 -> @guard_16
        sdir.edge{assign=["i2: 0"], condition="not(i1 < ni)"} @guard_18 -> @guard_36
        sdir.edge{assign=["i1: i1 + 1"], condition="not(j1 < nj)"} @guard_16 -> @guard_18
        sdir.edge{condition="j1 < nj"} @guard_16 -> @call_12
        sdir.edge{assign=["k1: 0"]} @call_12 -> @guard
        sdir.edge{condition="k1 < nk"} @guard -> @slice_tmp_14
        sdir.edge{assign=["j1: j1 + 1"], condition="not(k1 < nk)"} @guard -> @guard_16
        sdir.edge{assign=["k1: k1 + 1"]} @slice_tmp_14 -> @guard

        sdir.edge{condition="not(i2 < ni)"} @guard_36 -> @endfor_16
        sdir.edge{assign=["j2: 0"], condition="i2 < ni"} @guard_36 -> @guard_34
        sdir.edge{assign=["i2: i2 + 1"], condition="not(j2 < nl)"} @guard_34 -> @guard_36
        sdir.edge{condition="j2 < nl"} @guard_34 -> @slice_D_18
        sdir.edge{assign=["k2: 0"]} @slice_D_18 -> @guard_32
        sdir.edge{assign=["j2: j2 + 1"], condition="not(k2 < nj)"} @guard_32 -> @guard_34
        sdir.edge{condition="k2 < nj"} @guard_32 -> @slice_D_20
        sdir.edge{assign=["k2: k2 + 1"]} @slice_D_20 -> @guard_32
    }
}
