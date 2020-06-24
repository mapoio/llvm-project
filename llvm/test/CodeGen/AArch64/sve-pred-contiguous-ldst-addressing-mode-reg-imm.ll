; RUN: llc -mtriple=aarch64--linux-gnu -mattr=+sve --asm-verbose=false < %s 2>%t | FileCheck %s
; RUN: FileCheck --check-prefix=WARN --allow-empty %s <%t

; WARN-NOT: warning

; Range checks: for all the instruction tested in this file, the
; immediate must be within the range [-8, 7] (4-bit immediate). Out of
; range values are tested only in one case (following). Valid values
; are tested all through the rest of the file.

define void @imm_out_of_range(<vscale x 2 x i64> * %base, <vscale x 2 x i1> %mask) nounwind {
; CHECK-LABEL: imm_out_of_range:
; CHECK-NEXT: rdvl x8, #8
; CHECK-NEXT: add x8, x0, x8
; CHECK-NEXT: ld1d { z[[DATA:[0-9]+]].d }, p0/z, [x{{[0-9]+}}]
; CHECK-NEXT: rdvl x8, #-9
; CHECK-NEXT: add x8, x0, x8
; CHECK-NEXT: st1d { z[[DATA]].d }, p0, [x{{[0-9]+}}]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 2 x i64>, <vscale x 2 x i64>* %base, i64 8
  %data = call <vscale x 2 x i64> @llvm.masked.load.nxv2i64(<vscale x 2 x i64>* %base_load,
                                                            i32 1,
                                                            <vscale x 2 x i1> %mask,
                                                            <vscale x 2 x i64> undef)
  %base_store = getelementptr <vscale x 2 x i64>, <vscale x 2 x i64> * %base, i64 -9
  call void @llvm.masked.store.nxv2i64(<vscale x 2 x i64> %data,
                                       <vscale x 2 x i64>* %base_store,
                                       i32 1,
                                       <vscale x 2 x i1> %mask)
  ret void
}

; 2-lane contiguous load/stores

define void @test_masked_ldst_sv2i8(<vscale x 2 x i8> * %base, <vscale x 2 x i1> %mask) nounwind {
; CHECK-LABEL: test_masked_ldst_sv2i8:
; CHECK-NEXT: ld1sb { z[[DATA:[0-9]+]].d }, p0/z, [x0, #-8, mul vl]
; CHECK-NEXT: st1b { z[[DATA]].d }, p0, [x0, #-7, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 2 x i8>, <vscale x 2 x i8>* %base, i64 -8
  %data = call <vscale x 2 x i8> @llvm.masked.load.nxv2i8(<vscale x 2 x i8>* %base_load,
                                                          i32 1,
                                                          <vscale x 2 x i1> %mask,
                                                          <vscale x 2 x i8> undef)
  %base_store = getelementptr <vscale x 2 x i8>, <vscale x 2 x i8> * %base, i64 -7
  call void @llvm.masked.store.nxv2i8(<vscale x 2 x i8> %data,
                                      <vscale x 2 x i8>* %base_store,
                                      i32 1,
                                      <vscale x 2 x i1> %mask)
  ret void
}

define void @test_masked_ldst_sv2i16(<vscale x 2 x i16> * %base, <vscale x 2 x i1> %mask) nounwind {
; CHECK-LABEL: test_masked_ldst_sv2i16:
; CHECK-NEXT: ld1sh { z[[DATA:[0-9]+]].d }, p0/z, [x0, #-8, mul vl]
; CHECK-NEXT: st1h { z[[DATA]].d }, p0, [x0, #-7, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 2 x i16>, <vscale x 2 x i16>* %base, i64 -8
  %data = call <vscale x 2 x i16> @llvm.masked.load.nxv2i16(<vscale x 2 x i16>* %base_load,
                                                            i32 1,
                                                            <vscale x 2 x i1> %mask,
                                                            <vscale x 2 x i16> undef)
  %base_store = getelementptr <vscale x 2 x i16>, <vscale x 2 x i16> * %base, i64 -7
  call void @llvm.masked.store.nxv2i16(<vscale x 2 x i16> %data,
                                       <vscale x 2 x i16>* %base_store,
                                       i32 1,
                                       <vscale x 2 x i1> %mask)
  ret void
}


define void @test_masked_ldst_sv2i32(<vscale x 2 x i32> * %base, <vscale x 2 x i1> %mask) nounwind {
; CHECK-LABEL: test_masked_ldst_sv2i32:
; CHECK-NEXT: ld1sw { z[[DATA:[0-9]+]].d }, p0/z, [x0, #-8, mul vl]
; CHECK-NEXT: st1w { z[[DATA]].d }, p0, [x0, #-7, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 2 x i32>, <vscale x 2 x i32>* %base, i64 -8
  %data = call <vscale x 2 x i32> @llvm.masked.load.nxv2i32(<vscale x 2 x i32>* %base_load,
                                                            i32 1,
                                                            <vscale x 2 x i1> %mask,
                                                            <vscale x 2 x i32> undef)
  %base_store = getelementptr <vscale x 2 x i32>, <vscale x 2 x i32> * %base, i64 -7
  call void @llvm.masked.store.nxv2i32(<vscale x 2 x i32> %data,
                                       <vscale x 2 x i32>* %base_store,
                                       i32 1,
                                       <vscale x 2 x i1> %mask)
  ret void
}

define void @test_masked_ldst_sv2i64(<vscale x 2 x i64> * %base, <vscale x 2 x i1> %mask) nounwind {
; CHECK-LABEL: test_masked_ldst_sv2i64:
; CHECK-NEXT: ld1d { z[[DATA:[0-9]+]].d }, p0/z, [x0, #-8, mul vl]
; CHECK-NEXT: st1d { z[[DATA]].d }, p0, [x0, #-7, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 2 x i64>, <vscale x 2 x i64>* %base, i64 -8
  %data = call <vscale x 2 x i64> @llvm.masked.load.nxv2i64(<vscale x 2 x i64>* %base_load,
                                                            i32 1,
                                                            <vscale x 2 x i1> %mask,
                                                            <vscale x 2 x i64> undef)
  %base_store = getelementptr <vscale x 2 x i64>, <vscale x 2 x i64> * %base, i64 -7
  call void @llvm.masked.store.nxv2i64(<vscale x 2 x i64> %data,
                                       <vscale x 2 x i64>* %base_store,
                                       i32 1,
                                       <vscale x 2 x i1> %mask)
  ret void
}

define void @test_masked_ldst_sv2f16(<vscale x 2 x half> * %base, <vscale x 2 x i1> %mask) nounwind {
; CHECK-LABEL: test_masked_ldst_sv2f16:
; CHECK-NEXT: ld1h { z[[DATA:[0-9]+]].d }, p0/z, [x0, #-8, mul vl]
; CHECK-NEXT: st1h { z[[DATA]].d }, p0, [x0, #-7, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 2 x half>, <vscale x 2 x half>* %base, i64 -8
  %data = call <vscale x 2 x half> @llvm.masked.load.nxv2f16(<vscale x 2 x half>* %base_load,
                                                             i32 1,
                                                             <vscale x 2 x i1> %mask,
                                                             <vscale x 2 x half> undef)
  %base_store = getelementptr <vscale x 2 x half>, <vscale x 2 x half> * %base, i64 -7
  call void @llvm.masked.store.nxv2f16(<vscale x 2 x half> %data,
                                       <vscale x 2 x half>* %base_store,
                                       i32 1,
                                       <vscale x 2 x i1> %mask)
  ret void
}


define void @test_masked_ldst_sv2f32(<vscale x 2 x float> * %base, <vscale x 2 x i1> %mask) nounwind {
; CHECK-LABEL: test_masked_ldst_sv2f32:
; CHECK-NEXT: ld1w { z[[DATA:[0-9]+]].d }, p0/z, [x0, #-8, mul vl]
; CHECK-NEXT: st1w { z[[DATA]].d }, p0, [x0, #-7, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 2 x float>, <vscale x 2 x float>* %base, i64 -8
  %data = call <vscale x 2 x float> @llvm.masked.load.nxv2f32(<vscale x 2 x float>* %base_load,
                                                              i32 1,
                                                              <vscale x 2 x i1> %mask,
                                                              <vscale x 2 x float> undef)
  %base_store = getelementptr <vscale x 2 x float>, <vscale x 2 x float> * %base, i64 -7
  call void @llvm.masked.store.nxv2f32(<vscale x 2 x float> %data,
                                       <vscale x 2 x float>* %base_store,
                                       i32 1,
                                       <vscale x 2 x i1> %mask)
  ret void
}

define void @test_masked_ldst_sv2f64(<vscale x 2 x double> * %base, <vscale x 2 x i1> %mask) nounwind {
; CHECK-LABEL: test_masked_ldst_sv2f64:
; CHECK-NEXT: ld1d { z[[DATA:[0-9]+]].d }, p0/z, [x0, #-6, mul vl]
; CHECK-NEXT: st1d { z[[DATA]].d }, p0, [x0, #-5, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 2 x double>, <vscale x 2 x double>* %base, i64 -6
  %data = call <vscale x 2 x double> @llvm.masked.load.nxv2f64(<vscale x 2 x double>* %base_load,
                                                               i32 1,
                                                               <vscale x 2 x i1> %mask,
                                                               <vscale x 2 x double> undef)
  %base_store = getelementptr <vscale x 2 x double>, <vscale x 2 x double> * %base, i64 -5
  call void @llvm.masked.store.nxv2f64(<vscale x 2 x double> %data,
                                       <vscale x 2 x double>* %base_store,
                                       i32 1,
                                       <vscale x 2 x i1> %mask)
  ret void
}

; 2-lane zero/sign extended contiguous loads.

define <vscale x 2 x i64> @masked_zload_sv2i8_to_sv2i64(<vscale x 2 x i8>* %base, <vscale x 2 x i1> %mask) nounwind {
; CHECK-LABEL: masked_zload_sv2i8_to_sv2i64:
; CHECK-NEXT: ld1b { z0.d }, p0/z, [x0, #-4, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 2 x i8>, <vscale x 2 x i8>* %base, i64 -4
  %load = call <vscale x 2 x i8> @llvm.masked.load.nxv2i8(<vscale x 2 x i8>* %base_load,
                                                          i32 1,
                                                          <vscale x 2 x i1> %mask,
                                                          <vscale x 2 x i8> undef)
  %ext = zext <vscale x 2 x i8> %load to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %ext
}

define <vscale x 2 x i64> @masked_sload_sv2i8_to_sv2i64(<vscale x 2 x i8>* %base, <vscale x 2 x i1> %mask) nounwind {
; CHECK-LABEL: masked_sload_sv2i8_to_sv2i64:
; CHECK-NEXT: ld1sb { z0.d }, p0/z, [x0, #-3, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 2 x i8>, <vscale x 2 x i8>* %base, i64 -3
  %load = call <vscale x 2 x i8> @llvm.masked.load.nxv2i8(<vscale x 2 x i8>* %base_load,
                                                          i32 1,
                                                          <vscale x 2 x i1> %mask,
                                                          <vscale x 2 x i8> undef)
  %ext = sext <vscale x 2 x i8> %load to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %ext
}

define <vscale x 2 x i64> @masked_zload_sv2i16_to_sv2i64(<vscale x 2 x i16>* %base, <vscale x 2 x i1> %mask) nounwind {
; CHECK-LABEL: masked_zload_sv2i16_to_sv2i64:
; CHECK-NEXT: ld1h { z0.d }, p0/z, [x0, #1, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 2 x i16>, <vscale x 2 x i16>* %base, i64 1
  %load = call <vscale x 2 x i16> @llvm.masked.load.nxv2i16(<vscale x 2 x i16>* %base_load,
                                                            i32 1,
                                                            <vscale x 2 x i1> %mask,
                                                            <vscale x 2 x i16> undef)
  %ext = zext <vscale x 2 x i16> %load to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %ext
}

define <vscale x 2 x i64> @masked_sload_sv2i16_to_sv2i64(<vscale x 2 x i16>* %base, <vscale x 2 x i1> %mask) nounwind {
; CHECK-LABEL: masked_sload_sv2i16_to_sv2i64:
; CHECK-NEXT: ld1sh { z0.d }, p0/z, [x0, #2, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 2 x i16>, <vscale x 2 x i16>* %base, i64 2
  %load = call <vscale x 2 x i16> @llvm.masked.load.nxv2i16(<vscale x 2 x i16>* %base_load,
                                                            i32 1,
                                                            <vscale x 2 x i1> %mask,
                                                            <vscale x 2 x i16> undef)
  %ext = sext <vscale x 2 x i16> %load to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %ext
}

define <vscale x 2 x i64> @masked_zload_sv2i32_to_sv2i64(<vscale x 2 x i32>* %base, <vscale x 2 x i1> %mask) nounwind {
; CHECK-LABEL: masked_zload_sv2i32_to_sv2i64:
; CHECK-NEXT: ld1w { z0.d }, p0/z, [x0, #-2, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 2 x i32>, <vscale x 2 x i32>* %base, i64 -2
  %load = call <vscale x 2 x i32> @llvm.masked.load.nxv2i32(<vscale x 2 x i32>* %base_load,
                                                            i32 1,
                                                            <vscale x 2 x i1> %mask,
                                                            <vscale x 2 x i32> undef)
  %ext = zext <vscale x 2 x i32> %load to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %ext
}

define <vscale x 2 x i64> @masked_sload_sv2i32_to_sv2i64(<vscale x 2 x i32>* %base, <vscale x 2 x i1> %mask) nounwind {
; CHECK-LABEL: masked_sload_sv2i32_to_sv2i64:
; CHECK-NEXT: ld1sw { z0.d }, p0/z, [x0, #-1, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 2 x i32>, <vscale x 2 x i32>* %base, i64 -1
  %load = call <vscale x 2 x i32> @llvm.masked.load.nxv2i32(<vscale x 2 x i32>* %base_load,
                                                            i32 1,
                                                            <vscale x 2 x i1> %mask,
                                                            <vscale x 2 x i32> undef)
  %ext = sext <vscale x 2 x i32> %load to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %ext
}

; 2-lane truncating contiguous stores.

define void @masked_trunc_store_sv2i64_to_sv2i8(<vscale x 2 x i64> %val, <vscale x 2 x i8> *%base, <vscale x 2 x i1> %mask) nounwind {
; CHECK-LABEL: masked_trunc_store_sv2i64_to_sv2i8:
; CHECK-NEXT: st1b { z0.d }, p0, [x0, #3, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 2 x i8>, <vscale x 2 x i8>* %base, i64 3
  %trunc = trunc <vscale x 2 x i64> %val to <vscale x 2 x i8>
  call void @llvm.masked.store.nxv2i8(<vscale x 2 x i8> %trunc,
                                      <vscale x 2 x i8> *%base_load,
                                      i32 1,
                                      <vscale x 2 x i1> %mask)
  ret void
}


define void @masked_trunc_store_sv2i64_to_sv2i16(<vscale x 2 x i64> %val, <vscale x 2 x i16> *%base, <vscale x 2 x i1> %mask) nounwind {
; CHECK-LABEL: masked_trunc_store_sv2i64_to_sv2i16:
; CHECK-NEXT: st1h { z0.d }, p0, [x0, #4, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 2 x i16>, <vscale x 2 x i16>* %base, i64 4
  %trunc = trunc <vscale x 2 x i64> %val to <vscale x 2 x i16>
  call void @llvm.masked.store.nxv2i16(<vscale x 2 x i16> %trunc,
                                       <vscale x 2 x i16> *%base_load,
                                       i32 1,
                                       <vscale x 2 x i1> %mask)
  ret void
}

define void @masked_trunc_store_sv2i64_to_sv2i32(<vscale x 2 x i64> %val, <vscale x 2 x i32> *%base, <vscale x 2 x i1> %mask) nounwind {
; CHECK-LABEL: masked_trunc_store_sv2i64_to_sv2i32:
; CHECK-NEXT: st1w { z0.d }, p0, [x0, #5, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 2 x i32>, <vscale x 2 x i32>* %base, i64 5
  %trunc = trunc <vscale x 2 x i64> %val to <vscale x 2 x i32>
  call void @llvm.masked.store.nxv2i32(<vscale x 2 x i32> %trunc,
                                       <vscale x 2 x i32> *%base_load,
                                       i32 1,
                                       <vscale x 2 x i1> %mask)
  ret void
}

; 4-lane contiguous load/stores.

define void @test_masked_ldst_sv4i8(<vscale x 4 x i8> * %base, <vscale x 4 x i1> %mask) nounwind {
; CHECK-LABEL: test_masked_ldst_sv4i8:
; CHECK-NEXT: ld1sb { z[[DATA:[0-9]+]].s }, p0/z, [x0, #-1, mul vl]
; CHECK-NEXT: st1b { z[[DATA]].s }, p0, [x0, #2, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 4 x i8>, <vscale x 4 x i8>* %base, i64 -1
  %data = call <vscale x 4 x i8> @llvm.masked.load.nxv4i8(<vscale x 4 x i8>* %base_load,
                                                          i32 1,
                                                          <vscale x 4 x i1> %mask,
                                                          <vscale x 4 x i8> undef)
  %base_store = getelementptr <vscale x 4 x i8>, <vscale x 4 x i8> * %base, i64 2
  call void @llvm.masked.store.nxv4i8(<vscale x 4 x i8> %data,
                                      <vscale x 4 x i8>* %base_store,
                                      i32 1,
                                      <vscale x 4 x i1> %mask)
  ret void
}

define void @test_masked_ldst_sv4i16(<vscale x 4 x i16> * %base, <vscale x 4 x i1> %mask) nounwind {
; CHECK-LABEL: test_masked_ldst_sv4i16:
; CHECK-NEXT: ld1sh { z[[DATA:[0-9]+]].s }, p0/z, [x0, #-1, mul vl]
; CHECK-NEXT: st1h { z[[DATA]].s }, p0, [x0, #2, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 4 x i16>, <vscale x 4 x i16>* %base, i64 -1
  %data = call <vscale x 4 x i16> @llvm.masked.load.nxv4i16(<vscale x 4 x i16>* %base_load,
                                                            i32 1,
                                                            <vscale x 4 x i1> %mask,
                                                            <vscale x 4 x i16> undef)
  %base_store = getelementptr <vscale x 4 x i16>, <vscale x 4 x i16> * %base, i64 2
  call void @llvm.masked.store.nxv4i16(<vscale x 4 x i16> %data,
                                       <vscale x 4 x i16>* %base_store,
                                       i32 1,
                                       <vscale x 4 x i1> %mask)
  ret void
}

define void @test_masked_ldst_sv4i32(<vscale x 4 x i32> * %base, <vscale x 4 x i1> %mask) nounwind {
; CHECK-LABEL: test_masked_ldst_sv4i32:
; CHECK-NEXT: ld1w { z[[DATA:[0-9]+]].s }, p0/z, [x0, #6, mul vl]
; CHECK-NEXT: st1w { z[[DATA]].s }, p0, [x0, #7, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32>* %base, i64 6
  %data = call <vscale x 4 x i32> @llvm.masked.load.nxv4i32(<vscale x 4 x i32>* %base_load,
                                                            i32 1,
                                                            <vscale x 4 x i1> %mask,
                                                            <vscale x 4 x i32> undef)
  %base_store = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32> * %base, i64 7
  call void @llvm.masked.store.nxv4i32(<vscale x 4 x i32> %data,
                                       <vscale x 4 x i32>* %base_store,
                                       i32 1,
                                       <vscale x 4 x i1> %mask)
  ret void
}

define void @test_masked_ldst_sv4f16(<vscale x 4 x half> * %base, <vscale x 4 x i1> %mask) nounwind {
; CHECK-LABEL: test_masked_ldst_sv4f16:
; CHECK-NEXT: ld1h { z[[DATA:[0-9]+]].s }, p0/z, [x0, #-1, mul vl]
; CHECK-NEXT: st1h { z[[DATA]].s }, p0, [x0, #2, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 4 x half>, <vscale x 4 x half>* %base, i64 -1
  %data = call <vscale x 4 x half> @llvm.masked.load.nxv4f16(<vscale x 4 x half>* %base_load,
                                                             i32 1,
                                                             <vscale x 4 x i1> %mask,
                                                             <vscale x 4 x half> undef)
  %base_store = getelementptr <vscale x 4 x half>, <vscale x 4 x half> * %base, i64 2
  call void @llvm.masked.store.nxv4f16(<vscale x 4 x half> %data,
                                       <vscale x 4 x half>* %base_store,
                                       i32 1,
                                       <vscale x 4 x i1> %mask)
  ret void
}

define void @test_masked_ldst_sv4f32(<vscale x 4 x float> * %base, <vscale x 4 x i1> %mask) nounwind {
; CHECK-LABEL: test_masked_ldst_sv4f32:
; CHECK-NEXT: ld1w { z[[DATA:[0-9]+]].s }, p0/z, [x0, #-1, mul vl]
; CHECK-NEXT: st1w { z[[DATA]].s }, p0, [x0, #2, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 4 x float>, <vscale x 4 x float>* %base, i64 -1
  %data = call <vscale x 4 x float> @llvm.masked.load.nxv4f32(<vscale x 4 x float>* %base_load,
                                                              i32 1,
                                                              <vscale x 4 x i1> %mask,
                                                              <vscale x 4 x float> undef)
  %base_store = getelementptr <vscale x 4 x float>, <vscale x 4 x float> * %base, i64 2
  call void @llvm.masked.store.nxv4f32(<vscale x 4 x float> %data,
                                       <vscale x 4 x float>* %base_store,
                                       i32 1,
                                       <vscale x 4 x i1> %mask)
  ret void
}

; 4-lane zero/sign extended contiguous loads.

define <vscale x 4 x i32> @masked_zload_sv4i8_to_sv4i32(<vscale x 4 x i8>* %base, <vscale x 4 x i1> %mask) nounwind {
; CHECK-LABEL: masked_zload_sv4i8_to_sv4i32:
; CHECK-NEXT: ld1b { z0.s }, p0/z, [x0, #-4, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 4 x i8>, <vscale x 4 x i8>* %base, i64 -4
  %load = call <vscale x 4 x i8> @llvm.masked.load.nxv4i8(<vscale x 4 x i8>* %base_load,
                                                          i32 1,
                                                          <vscale x 4 x i1> %mask,
                                                          <vscale x 4 x i8> undef)
  %ext = zext <vscale x 4 x i8> %load to <vscale x 4 x i32>
  ret <vscale x 4 x i32> %ext
}

define <vscale x 4 x i32> @masked_sload_sv4i8_to_sv4i32(<vscale x 4 x i8>* %base, <vscale x 4 x i1> %mask) nounwind {
; CHECK-LABEL: masked_sload_sv4i8_to_sv4i32:
; CHECK-NEXT: ld1sb { z0.s }, p0/z, [x0, #-3, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 4 x i8>, <vscale x 4 x i8>* %base, i64 -3
  %load = call <vscale x 4 x i8> @llvm.masked.load.nxv4i8(<vscale x 4 x i8>* %base_load,
                                                          i32 1,
                                                          <vscale x 4 x i1> %mask,
                                                          <vscale x 4 x i8> undef)
  %ext = sext <vscale x 4 x i8> %load to <vscale x 4 x i32>
  ret <vscale x 4 x i32> %ext
}

define <vscale x 4 x i32> @masked_zload_sv4i16_to_sv4i32(<vscale x 4 x i16>* %base, <vscale x 4 x i1> %mask) nounwind {
; CHECK-LABEL: masked_zload_sv4i16_to_sv4i32:
; CHECK-NEXT: ld1h { z0.s }, p0/z, [x0, #1, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 4 x i16>, <vscale x 4 x i16>* %base, i64 1
  %load = call <vscale x 4 x i16> @llvm.masked.load.nxv4i16(<vscale x 4 x i16>* %base_load,
                                                            i32 1,
                                                            <vscale x 4 x i1> %mask,
                                                            <vscale x 4 x i16> undef)
  %ext = zext <vscale x 4 x i16> %load to <vscale x 4 x i32>
  ret <vscale x 4 x i32> %ext
}

define <vscale x 4 x i32> @masked_sload_sv4i16_to_sv4i32(<vscale x 4 x i16>* %base, <vscale x 4 x i1> %mask) nounwind {
; CHECK-LABEL: masked_sload_sv4i16_to_sv4i32:
; CHECK-NEXT: ld1sh { z0.s }, p0/z, [x0, #2, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 4 x i16>, <vscale x 4 x i16>* %base, i64 2
  %load = call <vscale x 4 x i16> @llvm.masked.load.nxv4i16(<vscale x 4 x i16>* %base_load,
                                                            i32 1,
                                                            <vscale x 4 x i1> %mask,
                                                            <vscale x 4 x i16> undef)
  %ext = sext <vscale x 4 x i16> %load to <vscale x 4 x i32>
  ret <vscale x 4 x i32> %ext
}

; 4-lane truncating contiguous stores.

define void @masked_trunc_store_sv4i32_to_sv4i8(<vscale x 4 x i32> %val, <vscale x 4 x i8> *%base, <vscale x 4 x i1> %mask) nounwind {
; CHECK-LABEL: masked_trunc_store_sv4i32_to_sv4i8:
; CHECK-NEXT: st1b { z0.s }, p0, [x0, #3, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 4 x i8>, <vscale x 4 x i8>* %base, i64 3
  %trunc = trunc <vscale x 4 x i32> %val to <vscale x 4 x i8>
  call void @llvm.masked.store.nxv4i8(<vscale x 4 x i8> %trunc,
                                      <vscale x 4 x i8> *%base_load,
                                      i32 1,
                                      <vscale x 4 x i1> %mask)
  ret void
}


define void @masked_trunc_store_sv4i32_to_sv4i16(<vscale x 4 x i32> %val, <vscale x 4 x i16> *%base, <vscale x 4 x i1> %mask) nounwind {
; CHECK-LABEL: masked_trunc_store_sv4i32_to_sv4i16:
; CHECK-NEXT: st1h { z0.s }, p0, [x0, #4, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 4 x i16>, <vscale x 4 x i16>* %base, i64 4
  %trunc = trunc <vscale x 4 x i32> %val to <vscale x 4 x i16>
  call void @llvm.masked.store.nxv4i16(<vscale x 4 x i16> %trunc,
                                       <vscale x 4 x i16> *%base_load,
                                       i32 1,
                                       <vscale x 4 x i1> %mask)
  ret void
}

; 8-lane contiguous load/stores.

define void @test_masked_ldst_sv8i8(<vscale x 8 x i8> * %base, <vscale x 8 x i1> %mask) nounwind {
; CHECK-LABEL: test_masked_ldst_sv8i8:
; CHECK-NEXT: ld1sb { z[[DATA:[0-9]+]].h }, p0/z, [x0, #6, mul vl]
; CHECK-NEXT: st1b { z[[DATA]].h }, p0, [x0, #7, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 8 x i8>, <vscale x 8 x i8>* %base, i64 6
  %data = call <vscale x 8 x i8> @llvm.masked.load.nxv8i8(<vscale x 8 x i8>* %base_load,
                                                          i32 1,
                                                          <vscale x 8 x i1> %mask,
                                                          <vscale x 8 x i8> undef)
  %base_store = getelementptr <vscale x 8 x i8>, <vscale x 8 x i8> * %base, i64 7
  call void @llvm.masked.store.nxv8i8(<vscale x 8 x i8> %data,
                                      <vscale x 8 x i8>* %base_store,
                                      i32 1,
                                      <vscale x 8 x i1> %mask)
  ret void
}

define void @test_masked_ldst_sv8i16(<vscale x 8 x i16> * %base, <vscale x 8 x i1> %mask) nounwind {
; CHECK-LABEL: test_masked_ldst_sv8i16:
; CHECK-NEXT: ld1h { z[[DATA:[0-9]+]].h }, p0/z, [x0, #6, mul vl]
; CHECK-NEXT: st1h { z[[DATA]].h }, p0, [x0, #7, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 8 x i16>, <vscale x 8 x i16>* %base, i64 6
  %data = call <vscale x 8 x i16> @llvm.masked.load.nxv8i16(<vscale x 8 x i16>* %base_load,
                                                            i32 1,
                                                            <vscale x 8 x i1> %mask,
                                                            <vscale x 8 x i16> undef)
  %base_store = getelementptr <vscale x 8 x i16>, <vscale x 8 x i16> * %base, i64 7
  call void @llvm.masked.store.nxv8i16(<vscale x 8 x i16> %data,
                                       <vscale x 8 x i16>* %base_store,
                                       i32 1,
                                       <vscale x 8 x i1> %mask)
  ret void
}

define void @test_masked_ldst_sv8f16(<vscale x 8 x half> * %base, <vscale x 8 x i1> %mask) nounwind {
; CHECK-LABEL: test_masked_ldst_sv8f16:
; CHECK-NEXT: ld1h { z[[DATA:[0-9]+]].h }, p0/z, [x0, #-1, mul vl]
; CHECK-NEXT: st1h { z[[DATA]].h }, p0, [x0, #2, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 8 x half>, <vscale x 8 x half>* %base, i64 -1
  %data = call <vscale x 8 x half> @llvm.masked.load.nxv8f16(<vscale x 8 x half>* %base_load,
                                                             i32 1,
                                                             <vscale x 8 x i1> %mask,
                                                             <vscale x 8 x half> undef)
  %base_store = getelementptr <vscale x 8 x half>, <vscale x 8 x half> * %base, i64 2
  call void @llvm.masked.store.nxv8f16(<vscale x 8 x half> %data,
                                       <vscale x 8 x half>* %base_store,
                                       i32 1,
                                       <vscale x 8 x i1> %mask)
  ret void
}

; 8-lane zero/sign extended contiguous loads.

define <vscale x 8 x i16> @masked_zload_sv8i8_to_sv8i16(<vscale x 8 x i8>* %base, <vscale x 8 x i1> %mask) nounwind {
; CHECK-LABEL: masked_zload_sv8i8_to_sv8i16:
; CHECK-NEXT: ld1b { z0.h }, p0/z, [x0, #-4, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 8 x i8>, <vscale x 8 x i8>* %base, i64 -4
  %load = call <vscale x 8 x i8> @llvm.masked.load.nxv8i8(<vscale x 8 x i8>* %base_load,
                                                          i32 1,
                                                          <vscale x 8 x i1> %mask,
                                                          <vscale x 8 x i8> undef)
  %ext = zext <vscale x 8 x i8> %load to <vscale x 8 x i16>
  ret <vscale x 8 x i16> %ext
}

define <vscale x 8 x i16> @masked_sload_sv8i8_to_sv8i16(<vscale x 8 x i8>* %base, <vscale x 8 x i1> %mask) nounwind {
; CHECK-LABEL: masked_sload_sv8i8_to_sv8i16:
; CHECK-NEXT: ld1sb { z0.h }, p0/z, [x0, #-3, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 8 x i8>, <vscale x 8 x i8>* %base, i64 -3
  %load = call <vscale x 8 x i8> @llvm.masked.load.nxv8i8(<vscale x 8 x i8>* %base_load,
                                                          i32 1,
                                                          <vscale x 8 x i1> %mask,
                                                          <vscale x 8 x i8> undef)
  %ext = sext <vscale x 8 x i8> %load to <vscale x 8 x i16>
  ret <vscale x 8 x i16> %ext
}

; 8-lane truncating contiguous stores.

define void @masked_trunc_store_sv8i16_to_sv8i8(<vscale x 8 x i16> %val, <vscale x 8 x i8> *%base, <vscale x 8 x i1> %mask) nounwind {
; CHECK-LABEL: masked_trunc_store_sv8i16_to_sv8i8:
; CHECK-NEXT: st1b { z0.h }, p0, [x0, #3, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 8 x i8>, <vscale x 8 x i8>* %base, i64 3
  %trunc = trunc <vscale x 8 x i16> %val to <vscale x 8 x i8>
  call void @llvm.masked.store.nxv8i8(<vscale x 8 x i8> %trunc,
                                      <vscale x 8 x i8> *%base_load,
                                      i32 1,
                                      <vscale x 8 x i1> %mask)
  ret void
}

; 16-lane contiguous load/stores.

define void @test_masked_ldst_sv16i8(<vscale x 16 x i8> * %base, <vscale x 16 x i1> %mask) nounwind {
; CHECK-LABEL: test_masked_ldst_sv16i8:
; CHECK-NEXT: ld1b { z[[DATA:[0-9]+]].b }, p0/z, [x0, #6, mul vl]
; CHECK-NEXT: st1b { z[[DATA]].b }, p0, [x0, #7, mul vl]
; CHECK-NEXT: ret
  %base_load = getelementptr <vscale x 16 x i8>, <vscale x 16 x i8>* %base, i64 6
  %data = call <vscale x 16 x i8> @llvm.masked.load.nxv16i8(<vscale x 16 x i8>* %base_load,
                                                            i32 1,
                                                            <vscale x 16 x i1> %mask,
                                                            <vscale x 16 x i8> undef)
  %base_store = getelementptr <vscale x 16 x i8>, <vscale x 16 x i8> * %base, i64 7
  call void @llvm.masked.store.nxv16i8(<vscale x 16 x i8> %data,
                                       <vscale x 16 x i8>* %base_store,
                                       i32 1,
                                       <vscale x 16 x i1> %mask)
  ret void
}

; 2-element contiguous loads.
declare <vscale x 2 x i8>  @llvm.masked.load.nxv2i8 (<vscale x 2 x i8>* , i32, <vscale x 2 x i1>, <vscale x 2 x i8> )
declare <vscale x 2 x i16> @llvm.masked.load.nxv2i16(<vscale x 2 x i16>*, i32, <vscale x 2 x i1>, <vscale x 2 x i16>)
declare <vscale x 2 x i32> @llvm.masked.load.nxv2i32(<vscale x 2 x i32>*, i32, <vscale x 2 x i1>, <vscale x 2 x i32>)
declare <vscale x 2 x i64> @llvm.masked.load.nxv2i64(<vscale x 2 x i64>*, i32, <vscale x 2 x i1>, <vscale x 2 x i64>)
declare <vscale x 2 x half> @llvm.masked.load.nxv2f16(<vscale x 2 x half>*, i32, <vscale x 2 x i1>, <vscale x 2 x half>)
declare <vscale x 2 x float> @llvm.masked.load.nxv2f32(<vscale x 2 x float>*, i32, <vscale x 2 x i1>, <vscale x 2 x float>)
declare <vscale x 2 x double> @llvm.masked.load.nxv2f64(<vscale x 2 x double>*, i32, <vscale x 2 x i1>, <vscale x 2 x double>)

; 4-element contiguous loads.
declare <vscale x 4 x i8>  @llvm.masked.load.nxv4i8 (<vscale x 4 x i8>* , i32, <vscale x 4 x i1>, <vscale x 4 x i8> )
declare <vscale x 4 x i16> @llvm.masked.load.nxv4i16(<vscale x 4 x i16>*, i32, <vscale x 4 x i1>, <vscale x 4 x i16>)
declare <vscale x 4 x i32> @llvm.masked.load.nxv4i32(<vscale x 4 x i32>*, i32, <vscale x 4 x i1>, <vscale x 4 x i32>)
declare <vscale x 4 x half> @llvm.masked.load.nxv4f16(<vscale x 4 x half>*, i32, <vscale x 4 x i1>, <vscale x 4 x half>)
declare <vscale x 4 x float> @llvm.masked.load.nxv4f32(<vscale x 4 x float>*, i32, <vscale x 4 x i1>, <vscale x 4 x float>)

; 8-element contiguous loads.
declare <vscale x 8 x i8>  @llvm.masked.load.nxv8i8 (<vscale x 8 x i8>* , i32, <vscale x 8 x i1>, <vscale x 8 x i8> )
declare <vscale x 8 x i16> @llvm.masked.load.nxv8i16(<vscale x 8 x i16>*, i32, <vscale x 8 x i1>, <vscale x 8 x i16>)
declare <vscale x 8 x half> @llvm.masked.load.nxv8f16(<vscale x 8 x half>*, i32, <vscale x 8 x i1>, <vscale x 8 x half>)

; 16-element contiguous loads.
declare <vscale x 16 x i8> @llvm.masked.load.nxv16i8(<vscale x 16 x i8>*, i32, <vscale x 16 x i1>, <vscale x 16 x i8>)

; 2-element contiguous stores.
declare void @llvm.masked.store.nxv2i8 (<vscale x 2 x i8> , <vscale x 2 x i8>* , i32, <vscale x 2 x i1>)
declare void @llvm.masked.store.nxv2i16(<vscale x 2 x i16>, <vscale x 2 x i16>*, i32, <vscale x 2 x i1>)
declare void @llvm.masked.store.nxv2i32(<vscale x 2 x i32>, <vscale x 2 x i32>*, i32, <vscale x 2 x i1>)
declare void @llvm.masked.store.nxv2i64(<vscale x 2 x i64>, <vscale x 2 x i64>*, i32, <vscale x 2 x i1>)
declare void @llvm.masked.store.nxv2f16(<vscale x 2 x half>, <vscale x 2 x half>*, i32, <vscale x 2 x i1>)
declare void @llvm.masked.store.nxv2f32(<vscale x 2 x float>, <vscale x 2 x float>*, i32, <vscale x 2 x i1>)
declare void @llvm.masked.store.nxv2f64(<vscale x 2 x double>, <vscale x 2 x double>*, i32, <vscale x 2 x i1>)

; 4-element contiguous stores.
declare void @llvm.masked.store.nxv4i8 (<vscale x 4 x i8> , <vscale x 4 x i8>* , i32, <vscale x 4 x i1>)
declare void @llvm.masked.store.nxv4i16(<vscale x 4 x i16>, <vscale x 4 x i16>*, i32, <vscale x 4 x i1>)
declare void @llvm.masked.store.nxv4i32(<vscale x 4 x i32>, <vscale x 4 x i32>*, i32, <vscale x 4 x i1>)
declare void @llvm.masked.store.nxv4f16(<vscale x 4 x half>, <vscale x 4 x half>*, i32, <vscale x 4 x i1>)
declare void @llvm.masked.store.nxv4f32(<vscale x 4 x float>, <vscale x 4 x float>*, i32, <vscale x 4 x i1>)

; 8-element contiguous stores.
declare void @llvm.masked.store.nxv8i8 (<vscale x 8 x i8> , <vscale x 8 x i8>* , i32, <vscale x 8 x i1>)
declare void @llvm.masked.store.nxv8i16(<vscale x 8 x i16>, <vscale x 8 x i16>*, i32, <vscale x 8 x i1>)
declare void @llvm.masked.store.nxv8f16(<vscale x 8 x half>, <vscale x 8 x half>*, i32, <vscale x 8 x i1>)

; 16-element contiguous stores.
declare void @llvm.masked.store.nxv16i8(<vscale x 16 x i8>, <vscale x 16 x i8>*, i32, <vscale x 16 x i1>)
