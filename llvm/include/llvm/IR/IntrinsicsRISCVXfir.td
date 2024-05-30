//===- IntrinsicsRISCVXsnitch.td - Snitch intrinsics --------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines the Xfir intrinsics.
//
//===----------------------------------------------------------------------===//

class RISCVFIRIntrinsic {}

let TargetPrefix = "riscv" in {

  //===----------------------------------------------------------------------===//
  // Xfir extension

  def int_riscv_xfir_lw
      : ClangBuiltin<"__builtin_xfir_lw">,
        Intrinsic<[llvm_ptr_ty],
                  [llvm_i32_ty, llvm_ptr_ty, llvm_i32_ty],
                  [ImmArg<ArgIndex<0>>,  ImmArg<ArgIndex<2>>]>,
        RISCVFIRIntrinsic;

  def int_riscv_xfir_sw
      : ClangBuiltin<"__builtin_xfir_sw">,
        Intrinsic<[llvm_ptr_ty],
                  [llvm_ptr_ty, llvm_i32_ty, llvm_i32_ty, llvm_i32_ty],
                  [IntrWriteMem, ImmArg<ArgIndex<1>>, ImmArg<ArgIndex<2>>, ImmArg<ArgIndex<3>>]>,
        RISCVFIRIntrinsic;

  def int_riscv_xfir_dotp
      : ClangBuiltin<"__builtin_xfir_dotp">,
        Intrinsic<[],
                  [llvm_i32_ty, llvm_i32_ty, llvm_i32_ty],
                  [IntrNoMem, IntrHasSideEffects, ImmArg<ArgIndex<0>>, ImmArg<ArgIndex<1>>, ImmArg<ArgIndex<2>>]>,
        RISCVFIRIntrinsic;

}
