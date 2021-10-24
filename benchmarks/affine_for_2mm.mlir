// This file implements 2mm using affine.for

module {
    llvm.mlir.global private unnamed_addr constant @".strF"("%f\0A\00") {alignment = 1 : i64}
    llvm.mlir.global private unnamed_addr constant @".strI"("%d ms\0A\00") {alignment = 1 : i64}
   
    llvm.func @printf(!llvm.ptr<i8>, ...) -> i32
    llvm.func @clock() -> i64

    func @print_float(%19: f64) {
        %0 = llvm.mlir.constant(0 : i64) : i64
        %1 = llvm.mlir.addressof @".strF" : !llvm.ptr<array<4 x i8>>
        %2 = llvm.getelementptr %1[%0, %0] : (!llvm.ptr<array<4 x i8>>, i64, i64) -> !llvm.ptr<i8>
        %20 = llvm.call @printf(%2, %19) : (!llvm.ptr<i8>, f64) -> i32
        return
    }

    func @print_int(%19: i64) {
        %0 = llvm.mlir.constant(0 : i64) : i64
        %1 = llvm.mlir.addressof @".strI" : !llvm.ptr<array<7 x i8>>
        %2 = llvm.getelementptr %1[%0, %0] : (!llvm.ptr<array<7 x i8>>, i64, i64) -> !llvm.ptr<i8>
        %20 = llvm.call @printf(%2, %19) : (!llvm.ptr<i8>, i64) -> i32
        return
    }

    func @get_time() -> i64{
        %7 = llvm.call @clock() : () -> i64
        return %7 : i64
    }

    func @init_array(%A : memref<?x?xf64>, %B : memref<?x?xf64>, %C : memref<?x?xf64>, %D : memref<?x?xf64>, 
                     %ni: index, %nj: index, %nk: index, %nl: index) 
    {
        %1 = arith.constant 1 : index
        %2 = arith.constant 2 : index
        %3 = arith.constant 3 : index

        affine.for %i = 0 to %ni {
            affine.for %j = 0 to %nk {
                %ij = arith.muli %i, %j : index
                %ij_1 = arith.addi %ij, %1 : index

                %ij_1_64 = arith.index_cast %ij_1 : index to i64
                %ni_64 = arith.index_cast %ni : index to i64

                %rem = llvm.urem %ij_1_64, %ni_64 : i64
                %rem_f = llvm.bitcast %rem : i64 to f64
                %ni_64_f = llvm.bitcast %ni_64 : i64 to f64

                %entry = llvm.fdiv %rem_f, %ni_64_f : f64
                memref.store %entry, %A[%i, %j] : memref<?x?xf64>
            }
        }

        affine.for %i = 0 to %nk {
            affine.for %j = 0 to %nj {
                %j_1 = arith.addi %j, %1 : index
                %ij_1 = arith.muli %i, %j_1 : index

                %ij_1_64 = arith.index_cast %ij_1 : index to i64
                %nj_64 = arith.index_cast %nj : index to i64

                %rem = llvm.urem %ij_1_64, %nj_64 : i64
                %rem_f = llvm.bitcast %rem : i64 to f64
                %nj_64_f = llvm.bitcast %nj_64 : i64 to f64

                %entry = llvm.fdiv %rem_f, %nj_64_f : f64
                memref.store %entry, %B[%i, %j] : memref<?x?xf64>
            }
        }

        affine.for %i = 0 to %nj {
            affine.for %j = 0 to %nl {
                %j_3 = arith.addi %j, %3 : index
                %ij_3 = arith.muli %i, %j_3 : index
                %ij_3_1 = arith.addi %ij_3, %1 : index

                %ij_3_1_64 = arith.index_cast %ij_3_1 : index to i64
                %nl_64 = arith.index_cast %nl : index to i64

                %rem = llvm.urem %ij_3_1_64, %nl_64 : i64
                %rem_f = llvm.bitcast %rem : i64 to f64
                %nl_64_f = llvm.bitcast %nl_64 : i64 to f64

                %entry = llvm.fdiv %rem_f, %nl_64_f : f64
                memref.store %entry, %C[%i, %j] : memref<?x?xf64>
            }
        }

        affine.for %i = 0 to %ni {
            affine.for %j = 0 to %nl {
                %j_2 = arith.addi %j, %2 : index
                %ij_2 = arith.muli %i, %j_2 : index

                %ij_2_64 = arith.index_cast %ij_2 : index to i64
                %nk_64 = arith.index_cast %nk : index to i64

                %rem = llvm.urem %ij_2_64, %nk_64 : i64
                %rem_f = llvm.bitcast %rem : i64 to f64
                %nk_64_f = llvm.bitcast %nk_64 : i64 to f64

                %entry = llvm.fdiv %rem_f, %nk_64_f : f64
                memref.store %entry, %D[%i, %j] : memref<?x?xf64>
            }
        }

        return
    }

    func @kernel_2mm(%tmp : memref<?x?xf64>, %A : memref<?x?xf64>, %B : memref<?x?xf64>, %C : memref<?x?xf64>, %D : memref<?x?xf64>, 
                     %ni: index, %nj: index, %nk: index, %nl: index, %alpha: f64, %beta: f64) 
    {   
        affine.for %i = 0 to %ni {
            affine.for %j = 0 to %nj {
                %0 = arith.constant 0.0 : f64
                memref.store %0, %tmp[%i, %j] : memref<?x?xf64>

                affine.for %k = 0 to %nk {
                    %A_v = memref.load %A[%i, %k] : memref<?x?xf64>
                    %B_v = memref.load %B[%k, %j] : memref<?x?xf64>
                    %tmp_v = memref.load %tmp[%i, %j] : memref<?x?xf64>

                    %AB_v = arith.mulf %A_v, %B_v : f64
                    %AB_a = arith.mulf %alpha, %AB_v : f64
                    %res = arith.addf %tmp_v, %AB_a : f64
                    memref.store %res, %tmp[%i, %j] : memref<?x?xf64>
                }
            }
        }

        affine.for %i = 0 to %ni {
            affine.for %j = 0 to %nl {
                %D_v = memref.load %D[%i, %j] : memref<?x?xf64>
                %D_b = arith.mulf %D_v, %beta : f64
                memref.store %D_b, %D[%i, %j] : memref<?x?xf64>

                affine.for %k = 0 to %nj {
                    %tmp_v = memref.load %tmp[%i, %k] : memref<?x?xf64>
                    %C_v = memref.load %C[%k, %j] : memref<?x?xf64>
                    %D_v2 = memref.load %D[%i, %j] : memref<?x?xf64>

                    %tmpC_v = arith.mulf %tmp_v, %C_v : f64
                    %res = arith.addf %D_v2, %tmpC_v : f64
                    memref.store %res, %D[%i, %j] : memref<?x?xf64>
                }
            }
        }
        return
    }

    func @main() -> i32 {
        %ni = arith.constant 800 : index
        %nj = arith.constant 900 : index
        %nk = arith.constant 1100 : index
        %nl = arith.constant 1200 : index

        %alpha = arith.constant 1.5 : f64
        %beta = arith.constant 1.2 : f64

        %A = memref.alloc(%ni, %nk) : memref<?x?xf64>
        %B = memref.alloc(%nk, %nj) : memref<?x?xf64>
        %C = memref.alloc(%nj, %nl) : memref<?x?xf64>
        %D = memref.alloc(%ni, %nl) : memref<?x?xf64>
        %tmp = memref.alloc(%ni, %nj) : memref<?x?xf64>

        call @init_array(%A, %B, %C, %D, %ni, %nj, %nk, %nl) : (memref<?x?xf64>,memref<?x?xf64>,memref<?x?xf64>,memref<?x?xf64>,index,index,index,index) -> ()
        
        %t_0 = call @get_time() : () -> i64
        call @kernel_2mm(%tmp, %A, %B, %C, %D, %ni, %nj, %nk, %nl, %alpha, %beta) : (memref<?x?xf64>,memref<?x?xf64>,memref<?x?xf64>,memref<?x?xf64>,memref<?x?xf64>,index,index,index,index,f64,f64) -> ()
        %t_1 = call @get_time() : () -> i64

        %t_e = arith.subi %t_1, %t_0 : i64
        %mtm = arith.constant 1000 : i64
        %t_e_ms = llvm.udiv %t_e, %mtm  : i64
        call @print_int(%t_e_ms) : (i64) -> ()

        //%i = arith.constant 0 : index
        //%j = arith.constant 0 : index
        //%n = memref.load %D[%i,%j] : memref<?x?xf64>
        //call @print_float(%n) : (f64) -> ()

        %0 = arith.constant 0 : i32
        return %0 : i32
    }
}
