//===-- RISCVInstrInfoXfir.td ------------------------------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file describes the RISC-V instructions from the FIR extension (Xfir). 
//
//===----------------------------------------------------------------------===//

// simm7 immediate
def simm7 : RISCVSImmLeafOp<7> {
  let MCOperandPredicate = [{
    int64_t Imm;
    if (MCOp.evaluateAsConstantImm(Imm))
      return isInt<7>(Imm);
    return MCOp.isBareSymbolRef();
  }];
}

// tsimm7 target immediate
def tsimm7 : Operand<XLenVT>, TImmLeaf<XLenVT, [{return isInt<7>(Imm);}]> {
  let ParserMatchClass = SImmAsmOperand<7>;
  let EncoderMethod = "getImmOpValue";
  let DecoderMethod = "decodeSImmOperand<7>";
  let MCOperandPredicate = [{
    int64_t Imm;
    if (MCOp.evaluateAsConstantImm(Imm))
      return isInt<7>(Imm);
    return MCOp.isBareSymbolRef();
  }];
}

// tsimm12 target immediate
def tsimm12 : Operand<XLenVT>, TImmLeaf<XLenVT, [{return isInt<12>(Imm);}]> {
  let ParserMatchClass = SImmAsmOperand<12>;
  let EncoderMethod = "getImmOpValue";
  let DecoderMethod = "decodeSImmOperand<12>";
  let MCOperandPredicate = [{
    int64_t Imm;
    if (MCOp.evaluateAsConstantImm(Imm))
      return isInt<12>(Imm);
    return MCOp.isBareSymbolRef();
  }];
}

let Predicates = [IsRV32, HasExtXfir] in {

// Instructions

let hasSideEffects = 1, mayLoad = 1, mayStore = 1 in 
def XFIRLW : RVInstI<0b000, OPC_CUSTOM_2, (outs GPR:$rs1_wb),
                   (ins uimm5:$rd, GPR:$rs1, simm12:$imm12),
                   "xfirlw", "$rd, ${imm12}(${rs1})">,
             Sched<[WriteLDW, WriteSTW, ReadMemBase]>
{
  let Constraints = "$rs1 = $rs1_wb";
}

let hasSideEffects = 1, mayLoad = 0, mayStore = 1 in 
def XFIRSW : RVInstS<0b001, OPC_CUSTOM_2, (outs GPR:$rs1_wb),
                   (ins GPR:$rs1, uimm5:$rs2, uimm5:$rs_a, uimm7:$rs_b),
                   "xfirsw", "$rs2, ${rs_b}(${rs1}), ${rs_a}">,
             Sched<[WriteSTW, ReadMemBase]>
{
  bits<5> rs_a;
  bits<7> rs_b;

  let imm12{4-0} = rs_a;
  let imm12{11-5} = rs_b; 
  let Constraints = "$rs1 = $rs1_wb";
}


// Instrinsics

def : Pat<(int_riscv_xfir_lw tuimm5:$rd, GPR:$rs1, tsimm12:$imm12),
          (XFIRLW tuimm5:$rd, GPR:$rs1, tsimm12:$imm12)>;

def : Pat<(int_riscv_xfir_sw GPR:$rs1, tuimm5:$rs2, tuimm5:$rs_a, tsimm7:$rs_b),
          (XFIRSW GPR:$rs1, tuimm5:$rs2, tuimm5:$rs_a, tsimm7:$rs_b)>;


}
