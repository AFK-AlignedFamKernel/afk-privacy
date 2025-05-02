use core::circuit::{
    CircuitElement as CE, CircuitInput as CI, CircuitInputs, CircuitOutputsTrait, EvalCircuitTrait,
    circuit_add, circuit_inverse, circuit_mul, circuit_sub, u384,
};
use garaga::core::circuit::AddInputResultTrait2;
use garaga::definitions::{G1Point, get_BN254_modulus, get_GRUMPKIN_modulus};
use garaga::ec_ops::FunctionFelt;

#[inline(always)]
pub fn run_GRUMPKIN_HONK_SUMCHECK_SIZE_15_PUB_4_circuit(
    p_public_inputs: Span<u256>,
    p_public_inputs_offset: u384,
    sumcheck_univariates_flat: Span<u256>,
    sumcheck_evaluations: Span<u256>,
    tp_sum_check_u_challenges: Span<u128>,
    tp_gate_challenges: Span<u128>,
    tp_eta_1: u128,
    tp_eta_2: u128,
    tp_eta_3: u128,
    tp_beta: u128,
    tp_gamma: u128,
    tp_base_rlc: u384,
    tp_alphas: Span<u128>,
) -> (u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x1
    let in1 = CE::<CI<1>> {}; // 0x8000
    let in2 = CE::<CI<2>> {}; // 0x0
    let in3 = CE::<CI<3>> {}; // 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593efffec51
    let in4 = CE::<CI<4>> {}; // 0x2d0
    let in5 = CE::<CI<5>> {}; // 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593efffff11
    let in6 = CE::<CI<6>> {}; // 0x90
    let in7 = CE::<CI<7>> {}; // 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593efffff71
    let in8 = CE::<CI<8>> {}; // 0xf0
    let in9 = CE::<CI<9>> {}; // 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593effffd31
    let in10 = CE::<CI<10>> {}; // 0x13b0
    let in11 = CE::<CI<11>> {}; // 0x2
    let in12 = CE::<CI<12>> {}; // 0x3
    let in13 = CE::<CI<13>> {}; // 0x4
    let in14 = CE::<CI<14>> {}; // 0x5
    let in15 = CE::<CI<15>> {}; // 0x6
    let in16 = CE::<CI<16>> {}; // 0x7
    let in17 = CE::<
        CI<17>,
    > {}; // 0x183227397098d014dc2822db40c0ac2e9419f4243cdcb848a1f0fac9f8000000
    let in18 = CE::<CI<18>> {}; // -0x1 % p
    let in19 = CE::<CI<19>> {}; // -0x2 % p
    let in20 = CE::<CI<20>> {}; // -0x3 % p
    let in21 = CE::<CI<21>> {}; // 0x11
    let in22 = CE::<CI<22>> {}; // 0x9
    let in23 = CE::<CI<23>> {}; // 0x100000000000000000
    let in24 = CE::<CI<24>> {}; // 0x4000
    let in25 = CE::<
        CI<25>,
    > {}; // 0x10dc6e9c006ea38b04b1e03b4bd9490c0d03f98929ca1d7fb56821fd19d3b6e7
    let in26 = CE::<CI<26>> {}; // 0xc28145b6a44df3e0149b3d0a30b3bb599df9756d4dd9b84a86b38cfb45a740b
    let in27 = CE::<CI<27>> {}; // 0x544b8338791518b2c7645a50392798b21f75bb60e3596170067d00141cac15
    let in28 = CE::<
        CI<28>,
    > {}; // 0x222c01175718386f2e2e82eb122789e352e105a3b8fa852613bc534433ee428b

    // INPUT stack
    let (in29, in30, in31) = (CE::<CI<29>> {}, CE::<CI<30>> {}, CE::<CI<31>> {});
    let (in32, in33, in34) = (CE::<CI<32>> {}, CE::<CI<33>> {}, CE::<CI<34>> {});
    let (in35, in36, in37) = (CE::<CI<35>> {}, CE::<CI<36>> {}, CE::<CI<37>> {});
    let (in38, in39, in40) = (CE::<CI<38>> {}, CE::<CI<39>> {}, CE::<CI<40>> {});
    let (in41, in42, in43) = (CE::<CI<41>> {}, CE::<CI<42>> {}, CE::<CI<43>> {});
    let (in44, in45, in46) = (CE::<CI<44>> {}, CE::<CI<45>> {}, CE::<CI<46>> {});
    let (in47, in48, in49) = (CE::<CI<47>> {}, CE::<CI<48>> {}, CE::<CI<49>> {});
    let (in50, in51, in52) = (CE::<CI<50>> {}, CE::<CI<51>> {}, CE::<CI<52>> {});
    let (in53, in54, in55) = (CE::<CI<53>> {}, CE::<CI<54>> {}, CE::<CI<55>> {});
    let (in56, in57, in58) = (CE::<CI<56>> {}, CE::<CI<57>> {}, CE::<CI<58>> {});
    let (in59, in60, in61) = (CE::<CI<59>> {}, CE::<CI<60>> {}, CE::<CI<61>> {});
    let (in62, in63, in64) = (CE::<CI<62>> {}, CE::<CI<63>> {}, CE::<CI<64>> {});
    let (in65, in66, in67) = (CE::<CI<65>> {}, CE::<CI<66>> {}, CE::<CI<67>> {});
    let (in68, in69, in70) = (CE::<CI<68>> {}, CE::<CI<69>> {}, CE::<CI<70>> {});
    let (in71, in72, in73) = (CE::<CI<71>> {}, CE::<CI<72>> {}, CE::<CI<73>> {});
    let (in74, in75, in76) = (CE::<CI<74>> {}, CE::<CI<75>> {}, CE::<CI<76>> {});
    let (in77, in78, in79) = (CE::<CI<77>> {}, CE::<CI<78>> {}, CE::<CI<79>> {});
    let (in80, in81, in82) = (CE::<CI<80>> {}, CE::<CI<81>> {}, CE::<CI<82>> {});
    let (in83, in84, in85) = (CE::<CI<83>> {}, CE::<CI<84>> {}, CE::<CI<85>> {});
    let (in86, in87, in88) = (CE::<CI<86>> {}, CE::<CI<87>> {}, CE::<CI<88>> {});
    let (in89, in90, in91) = (CE::<CI<89>> {}, CE::<CI<90>> {}, CE::<CI<91>> {});
    let (in92, in93, in94) = (CE::<CI<92>> {}, CE::<CI<93>> {}, CE::<CI<94>> {});
    let (in95, in96, in97) = (CE::<CI<95>> {}, CE::<CI<96>> {}, CE::<CI<97>> {});
    let (in98, in99, in100) = (CE::<CI<98>> {}, CE::<CI<99>> {}, CE::<CI<100>> {});
    let (in101, in102, in103) = (CE::<CI<101>> {}, CE::<CI<102>> {}, CE::<CI<103>> {});
    let (in104, in105, in106) = (CE::<CI<104>> {}, CE::<CI<105>> {}, CE::<CI<106>> {});
    let (in107, in108, in109) = (CE::<CI<107>> {}, CE::<CI<108>> {}, CE::<CI<109>> {});
    let (in110, in111, in112) = (CE::<CI<110>> {}, CE::<CI<111>> {}, CE::<CI<112>> {});
    let (in113, in114, in115) = (CE::<CI<113>> {}, CE::<CI<114>> {}, CE::<CI<115>> {});
    let (in116, in117, in118) = (CE::<CI<116>> {}, CE::<CI<117>> {}, CE::<CI<118>> {});
    let (in119, in120, in121) = (CE::<CI<119>> {}, CE::<CI<120>> {}, CE::<CI<121>> {});
    let (in122, in123, in124) = (CE::<CI<122>> {}, CE::<CI<123>> {}, CE::<CI<124>> {});
    let (in125, in126, in127) = (CE::<CI<125>> {}, CE::<CI<126>> {}, CE::<CI<127>> {});
    let (in128, in129, in130) = (CE::<CI<128>> {}, CE::<CI<129>> {}, CE::<CI<130>> {});
    let (in131, in132, in133) = (CE::<CI<131>> {}, CE::<CI<132>> {}, CE::<CI<133>> {});
    let (in134, in135, in136) = (CE::<CI<134>> {}, CE::<CI<135>> {}, CE::<CI<136>> {});
    let (in137, in138, in139) = (CE::<CI<137>> {}, CE::<CI<138>> {}, CE::<CI<139>> {});
    let (in140, in141, in142) = (CE::<CI<140>> {}, CE::<CI<141>> {}, CE::<CI<142>> {});
    let (in143, in144, in145) = (CE::<CI<143>> {}, CE::<CI<144>> {}, CE::<CI<145>> {});
    let (in146, in147, in148) = (CE::<CI<146>> {}, CE::<CI<147>> {}, CE::<CI<148>> {});
    let (in149, in150, in151) = (CE::<CI<149>> {}, CE::<CI<150>> {}, CE::<CI<151>> {});
    let (in152, in153, in154) = (CE::<CI<152>> {}, CE::<CI<153>> {}, CE::<CI<154>> {});
    let (in155, in156, in157) = (CE::<CI<155>> {}, CE::<CI<156>> {}, CE::<CI<157>> {});
    let (in158, in159, in160) = (CE::<CI<158>> {}, CE::<CI<159>> {}, CE::<CI<160>> {});
    let (in161, in162, in163) = (CE::<CI<161>> {}, CE::<CI<162>> {}, CE::<CI<163>> {});
    let (in164, in165, in166) = (CE::<CI<164>> {}, CE::<CI<165>> {}, CE::<CI<166>> {});
    let (in167, in168, in169) = (CE::<CI<167>> {}, CE::<CI<168>> {}, CE::<CI<169>> {});
    let (in170, in171, in172) = (CE::<CI<170>> {}, CE::<CI<171>> {}, CE::<CI<172>> {});
    let (in173, in174, in175) = (CE::<CI<173>> {}, CE::<CI<174>> {}, CE::<CI<175>> {});
    let (in176, in177, in178) = (CE::<CI<176>> {}, CE::<CI<177>> {}, CE::<CI<178>> {});
    let (in179, in180, in181) = (CE::<CI<179>> {}, CE::<CI<180>> {}, CE::<CI<181>> {});
    let (in182, in183, in184) = (CE::<CI<182>> {}, CE::<CI<183>> {}, CE::<CI<184>> {});
    let (in185, in186, in187) = (CE::<CI<185>> {}, CE::<CI<186>> {}, CE::<CI<187>> {});
    let (in188, in189, in190) = (CE::<CI<188>> {}, CE::<CI<189>> {}, CE::<CI<190>> {});
    let (in191, in192, in193) = (CE::<CI<191>> {}, CE::<CI<192>> {}, CE::<CI<193>> {});
    let (in194, in195, in196) = (CE::<CI<194>> {}, CE::<CI<195>> {}, CE::<CI<196>> {});
    let (in197, in198, in199) = (CE::<CI<197>> {}, CE::<CI<198>> {}, CE::<CI<199>> {});
    let (in200, in201, in202) = (CE::<CI<200>> {}, CE::<CI<201>> {}, CE::<CI<202>> {});
    let (in203, in204, in205) = (CE::<CI<203>> {}, CE::<CI<204>> {}, CE::<CI<205>> {});
    let (in206, in207, in208) = (CE::<CI<206>> {}, CE::<CI<207>> {}, CE::<CI<208>> {});
    let (in209, in210, in211) = (CE::<CI<209>> {}, CE::<CI<210>> {}, CE::<CI<211>> {});
    let (in212, in213, in214) = (CE::<CI<212>> {}, CE::<CI<213>> {}, CE::<CI<214>> {});
    let (in215, in216, in217) = (CE::<CI<215>> {}, CE::<CI<216>> {}, CE::<CI<217>> {});
    let (in218, in219, in220) = (CE::<CI<218>> {}, CE::<CI<219>> {}, CE::<CI<220>> {});
    let (in221, in222, in223) = (CE::<CI<221>> {}, CE::<CI<222>> {}, CE::<CI<223>> {});
    let (in224, in225, in226) = (CE::<CI<224>> {}, CE::<CI<225>> {}, CE::<CI<226>> {});
    let (in227, in228, in229) = (CE::<CI<227>> {}, CE::<CI<228>> {}, CE::<CI<229>> {});
    let (in230, in231, in232) = (CE::<CI<230>> {}, CE::<CI<231>> {}, CE::<CI<232>> {});
    let (in233, in234, in235) = (CE::<CI<233>> {}, CE::<CI<234>> {}, CE::<CI<235>> {});
    let (in236, in237, in238) = (CE::<CI<236>> {}, CE::<CI<237>> {}, CE::<CI<238>> {});
    let (in239, in240, in241) = (CE::<CI<239>> {}, CE::<CI<240>> {}, CE::<CI<241>> {});
    let (in242, in243, in244) = (CE::<CI<242>> {}, CE::<CI<243>> {}, CE::<CI<244>> {});
    let (in245, in246, in247) = (CE::<CI<245>> {}, CE::<CI<246>> {}, CE::<CI<247>> {});
    let (in248, in249, in250) = (CE::<CI<248>> {}, CE::<CI<249>> {}, CE::<CI<250>> {});
    let (in251, in252, in253) = (CE::<CI<251>> {}, CE::<CI<252>> {}, CE::<CI<253>> {});
    let in254 = CE::<CI<254>> {};
    let t0 = circuit_add(in1, in33);
    let t1 = circuit_mul(in227, t0);
    let t2 = circuit_add(in228, t1);
    let t3 = circuit_add(in33, in0);
    let t4 = circuit_mul(in227, t3);
    let t5 = circuit_sub(in228, t4);
    let t6 = circuit_add(t2, in29);
    let t7 = circuit_mul(in0, t6);
    let t8 = circuit_add(t5, in29);
    let t9 = circuit_mul(in0, t8);
    let t10 = circuit_add(t2, in227);
    let t11 = circuit_sub(t5, in227);
    let t12 = circuit_add(t10, in30);
    let t13 = circuit_mul(t7, t12);
    let t14 = circuit_add(t11, in30);
    let t15 = circuit_mul(t9, t14);
    let t16 = circuit_add(t10, in227);
    let t17 = circuit_sub(t11, in227);
    let t18 = circuit_add(t16, in31);
    let t19 = circuit_mul(t13, t18);
    let t20 = circuit_add(t17, in31);
    let t21 = circuit_mul(t15, t20);
    let t22 = circuit_add(t16, in227);
    let t23 = circuit_sub(t17, in227);
    let t24 = circuit_add(t22, in32);
    let t25 = circuit_mul(t19, t24);
    let t26 = circuit_add(t23, in32);
    let t27 = circuit_mul(t21, t26);
    let t28 = circuit_inverse(t27);
    let t29 = circuit_mul(t25, t28);
    let t30 = circuit_add(in34, in35);
    let t31 = circuit_sub(t30, in2);
    let t32 = circuit_mul(t31, in229);
    let t33 = circuit_add(in2, t32);
    let t34 = circuit_mul(in229, in229);
    let t35 = circuit_sub(in194, in2);
    let t36 = circuit_mul(in0, t35);
    let t37 = circuit_sub(in194, in2);
    let t38 = circuit_mul(in3, t37);
    let t39 = circuit_inverse(t38);
    let t40 = circuit_mul(in34, t39);
    let t41 = circuit_add(in2, t40);
    let t42 = circuit_sub(in194, in0);
    let t43 = circuit_mul(t36, t42);
    let t44 = circuit_sub(in194, in0);
    let t45 = circuit_mul(in4, t44);
    let t46 = circuit_inverse(t45);
    let t47 = circuit_mul(in35, t46);
    let t48 = circuit_add(t41, t47);
    let t49 = circuit_sub(in194, in11);
    let t50 = circuit_mul(t43, t49);
    let t51 = circuit_sub(in194, in11);
    let t52 = circuit_mul(in5, t51);
    let t53 = circuit_inverse(t52);
    let t54 = circuit_mul(in36, t53);
    let t55 = circuit_add(t48, t54);
    let t56 = circuit_sub(in194, in12);
    let t57 = circuit_mul(t50, t56);
    let t58 = circuit_sub(in194, in12);
    let t59 = circuit_mul(in6, t58);
    let t60 = circuit_inverse(t59);
    let t61 = circuit_mul(in37, t60);
    let t62 = circuit_add(t55, t61);
    let t63 = circuit_sub(in194, in13);
    let t64 = circuit_mul(t57, t63);
    let t65 = circuit_sub(in194, in13);
    let t66 = circuit_mul(in7, t65);
    let t67 = circuit_inverse(t66);
    let t68 = circuit_mul(in38, t67);
    let t69 = circuit_add(t62, t68);
    let t70 = circuit_sub(in194, in14);
    let t71 = circuit_mul(t64, t70);
    let t72 = circuit_sub(in194, in14);
    let t73 = circuit_mul(in8, t72);
    let t74 = circuit_inverse(t73);
    let t75 = circuit_mul(in39, t74);
    let t76 = circuit_add(t69, t75);
    let t77 = circuit_sub(in194, in15);
    let t78 = circuit_mul(t71, t77);
    let t79 = circuit_sub(in194, in15);
    let t80 = circuit_mul(in9, t79);
    let t81 = circuit_inverse(t80);
    let t82 = circuit_mul(in40, t81);
    let t83 = circuit_add(t76, t82);
    let t84 = circuit_sub(in194, in16);
    let t85 = circuit_mul(t78, t84);
    let t86 = circuit_sub(in194, in16);
    let t87 = circuit_mul(in10, t86);
    let t88 = circuit_inverse(t87);
    let t89 = circuit_mul(in41, t88);
    let t90 = circuit_add(t83, t89);
    let t91 = circuit_mul(t90, t85);
    let t92 = circuit_sub(in209, in0);
    let t93 = circuit_mul(in194, t92);
    let t94 = circuit_add(in0, t93);
    let t95 = circuit_mul(in0, t94);
    let t96 = circuit_add(in42, in43);
    let t97 = circuit_sub(t96, t91);
    let t98 = circuit_mul(t97, t34);
    let t99 = circuit_add(t33, t98);
    let t100 = circuit_mul(t34, in229);
    let t101 = circuit_sub(in195, in2);
    let t102 = circuit_mul(in0, t101);
    let t103 = circuit_sub(in195, in2);
    let t104 = circuit_mul(in3, t103);
    let t105 = circuit_inverse(t104);
    let t106 = circuit_mul(in42, t105);
    let t107 = circuit_add(in2, t106);
    let t108 = circuit_sub(in195, in0);
    let t109 = circuit_mul(t102, t108);
    let t110 = circuit_sub(in195, in0);
    let t111 = circuit_mul(in4, t110);
    let t112 = circuit_inverse(t111);
    let t113 = circuit_mul(in43, t112);
    let t114 = circuit_add(t107, t113);
    let t115 = circuit_sub(in195, in11);
    let t116 = circuit_mul(t109, t115);
    let t117 = circuit_sub(in195, in11);
    let t118 = circuit_mul(in5, t117);
    let t119 = circuit_inverse(t118);
    let t120 = circuit_mul(in44, t119);
    let t121 = circuit_add(t114, t120);
    let t122 = circuit_sub(in195, in12);
    let t123 = circuit_mul(t116, t122);
    let t124 = circuit_sub(in195, in12);
    let t125 = circuit_mul(in6, t124);
    let t126 = circuit_inverse(t125);
    let t127 = circuit_mul(in45, t126);
    let t128 = circuit_add(t121, t127);
    let t129 = circuit_sub(in195, in13);
    let t130 = circuit_mul(t123, t129);
    let t131 = circuit_sub(in195, in13);
    let t132 = circuit_mul(in7, t131);
    let t133 = circuit_inverse(t132);
    let t134 = circuit_mul(in46, t133);
    let t135 = circuit_add(t128, t134);
    let t136 = circuit_sub(in195, in14);
    let t137 = circuit_mul(t130, t136);
    let t138 = circuit_sub(in195, in14);
    let t139 = circuit_mul(in8, t138);
    let t140 = circuit_inverse(t139);
    let t141 = circuit_mul(in47, t140);
    let t142 = circuit_add(t135, t141);
    let t143 = circuit_sub(in195, in15);
    let t144 = circuit_mul(t137, t143);
    let t145 = circuit_sub(in195, in15);
    let t146 = circuit_mul(in9, t145);
    let t147 = circuit_inverse(t146);
    let t148 = circuit_mul(in48, t147);
    let t149 = circuit_add(t142, t148);
    let t150 = circuit_sub(in195, in16);
    let t151 = circuit_mul(t144, t150);
    let t152 = circuit_sub(in195, in16);
    let t153 = circuit_mul(in10, t152);
    let t154 = circuit_inverse(t153);
    let t155 = circuit_mul(in49, t154);
    let t156 = circuit_add(t149, t155);
    let t157 = circuit_mul(t156, t151);
    let t158 = circuit_sub(in210, in0);
    let t159 = circuit_mul(in195, t158);
    let t160 = circuit_add(in0, t159);
    let t161 = circuit_mul(t95, t160);
    let t162 = circuit_add(in50, in51);
    let t163 = circuit_sub(t162, t157);
    let t164 = circuit_mul(t163, t100);
    let t165 = circuit_add(t99, t164);
    let t166 = circuit_mul(t100, in229);
    let t167 = circuit_sub(in196, in2);
    let t168 = circuit_mul(in0, t167);
    let t169 = circuit_sub(in196, in2);
    let t170 = circuit_mul(in3, t169);
    let t171 = circuit_inverse(t170);
    let t172 = circuit_mul(in50, t171);
    let t173 = circuit_add(in2, t172);
    let t174 = circuit_sub(in196, in0);
    let t175 = circuit_mul(t168, t174);
    let t176 = circuit_sub(in196, in0);
    let t177 = circuit_mul(in4, t176);
    let t178 = circuit_inverse(t177);
    let t179 = circuit_mul(in51, t178);
    let t180 = circuit_add(t173, t179);
    let t181 = circuit_sub(in196, in11);
    let t182 = circuit_mul(t175, t181);
    let t183 = circuit_sub(in196, in11);
    let t184 = circuit_mul(in5, t183);
    let t185 = circuit_inverse(t184);
    let t186 = circuit_mul(in52, t185);
    let t187 = circuit_add(t180, t186);
    let t188 = circuit_sub(in196, in12);
    let t189 = circuit_mul(t182, t188);
    let t190 = circuit_sub(in196, in12);
    let t191 = circuit_mul(in6, t190);
    let t192 = circuit_inverse(t191);
    let t193 = circuit_mul(in53, t192);
    let t194 = circuit_add(t187, t193);
    let t195 = circuit_sub(in196, in13);
    let t196 = circuit_mul(t189, t195);
    let t197 = circuit_sub(in196, in13);
    let t198 = circuit_mul(in7, t197);
    let t199 = circuit_inverse(t198);
    let t200 = circuit_mul(in54, t199);
    let t201 = circuit_add(t194, t200);
    let t202 = circuit_sub(in196, in14);
    let t203 = circuit_mul(t196, t202);
    let t204 = circuit_sub(in196, in14);
    let t205 = circuit_mul(in8, t204);
    let t206 = circuit_inverse(t205);
    let t207 = circuit_mul(in55, t206);
    let t208 = circuit_add(t201, t207);
    let t209 = circuit_sub(in196, in15);
    let t210 = circuit_mul(t203, t209);
    let t211 = circuit_sub(in196, in15);
    let t212 = circuit_mul(in9, t211);
    let t213 = circuit_inverse(t212);
    let t214 = circuit_mul(in56, t213);
    let t215 = circuit_add(t208, t214);
    let t216 = circuit_sub(in196, in16);
    let t217 = circuit_mul(t210, t216);
    let t218 = circuit_sub(in196, in16);
    let t219 = circuit_mul(in10, t218);
    let t220 = circuit_inverse(t219);
    let t221 = circuit_mul(in57, t220);
    let t222 = circuit_add(t215, t221);
    let t223 = circuit_mul(t222, t217);
    let t224 = circuit_sub(in211, in0);
    let t225 = circuit_mul(in196, t224);
    let t226 = circuit_add(in0, t225);
    let t227 = circuit_mul(t161, t226);
    let t228 = circuit_add(in58, in59);
    let t229 = circuit_sub(t228, t223);
    let t230 = circuit_mul(t229, t166);
    let t231 = circuit_add(t165, t230);
    let t232 = circuit_mul(t166, in229);
    let t233 = circuit_sub(in197, in2);
    let t234 = circuit_mul(in0, t233);
    let t235 = circuit_sub(in197, in2);
    let t236 = circuit_mul(in3, t235);
    let t237 = circuit_inverse(t236);
    let t238 = circuit_mul(in58, t237);
    let t239 = circuit_add(in2, t238);
    let t240 = circuit_sub(in197, in0);
    let t241 = circuit_mul(t234, t240);
    let t242 = circuit_sub(in197, in0);
    let t243 = circuit_mul(in4, t242);
    let t244 = circuit_inverse(t243);
    let t245 = circuit_mul(in59, t244);
    let t246 = circuit_add(t239, t245);
    let t247 = circuit_sub(in197, in11);
    let t248 = circuit_mul(t241, t247);
    let t249 = circuit_sub(in197, in11);
    let t250 = circuit_mul(in5, t249);
    let t251 = circuit_inverse(t250);
    let t252 = circuit_mul(in60, t251);
    let t253 = circuit_add(t246, t252);
    let t254 = circuit_sub(in197, in12);
    let t255 = circuit_mul(t248, t254);
    let t256 = circuit_sub(in197, in12);
    let t257 = circuit_mul(in6, t256);
    let t258 = circuit_inverse(t257);
    let t259 = circuit_mul(in61, t258);
    let t260 = circuit_add(t253, t259);
    let t261 = circuit_sub(in197, in13);
    let t262 = circuit_mul(t255, t261);
    let t263 = circuit_sub(in197, in13);
    let t264 = circuit_mul(in7, t263);
    let t265 = circuit_inverse(t264);
    let t266 = circuit_mul(in62, t265);
    let t267 = circuit_add(t260, t266);
    let t268 = circuit_sub(in197, in14);
    let t269 = circuit_mul(t262, t268);
    let t270 = circuit_sub(in197, in14);
    let t271 = circuit_mul(in8, t270);
    let t272 = circuit_inverse(t271);
    let t273 = circuit_mul(in63, t272);
    let t274 = circuit_add(t267, t273);
    let t275 = circuit_sub(in197, in15);
    let t276 = circuit_mul(t269, t275);
    let t277 = circuit_sub(in197, in15);
    let t278 = circuit_mul(in9, t277);
    let t279 = circuit_inverse(t278);
    let t280 = circuit_mul(in64, t279);
    let t281 = circuit_add(t274, t280);
    let t282 = circuit_sub(in197, in16);
    let t283 = circuit_mul(t276, t282);
    let t284 = circuit_sub(in197, in16);
    let t285 = circuit_mul(in10, t284);
    let t286 = circuit_inverse(t285);
    let t287 = circuit_mul(in65, t286);
    let t288 = circuit_add(t281, t287);
    let t289 = circuit_mul(t288, t283);
    let t290 = circuit_sub(in212, in0);
    let t291 = circuit_mul(in197, t290);
    let t292 = circuit_add(in0, t291);
    let t293 = circuit_mul(t227, t292);
    let t294 = circuit_add(in66, in67);
    let t295 = circuit_sub(t294, t289);
    let t296 = circuit_mul(t295, t232);
    let t297 = circuit_add(t231, t296);
    let t298 = circuit_mul(t232, in229);
    let t299 = circuit_sub(in198, in2);
    let t300 = circuit_mul(in0, t299);
    let t301 = circuit_sub(in198, in2);
    let t302 = circuit_mul(in3, t301);
    let t303 = circuit_inverse(t302);
    let t304 = circuit_mul(in66, t303);
    let t305 = circuit_add(in2, t304);
    let t306 = circuit_sub(in198, in0);
    let t307 = circuit_mul(t300, t306);
    let t308 = circuit_sub(in198, in0);
    let t309 = circuit_mul(in4, t308);
    let t310 = circuit_inverse(t309);
    let t311 = circuit_mul(in67, t310);
    let t312 = circuit_add(t305, t311);
    let t313 = circuit_sub(in198, in11);
    let t314 = circuit_mul(t307, t313);
    let t315 = circuit_sub(in198, in11);
    let t316 = circuit_mul(in5, t315);
    let t317 = circuit_inverse(t316);
    let t318 = circuit_mul(in68, t317);
    let t319 = circuit_add(t312, t318);
    let t320 = circuit_sub(in198, in12);
    let t321 = circuit_mul(t314, t320);
    let t322 = circuit_sub(in198, in12);
    let t323 = circuit_mul(in6, t322);
    let t324 = circuit_inverse(t323);
    let t325 = circuit_mul(in69, t324);
    let t326 = circuit_add(t319, t325);
    let t327 = circuit_sub(in198, in13);
    let t328 = circuit_mul(t321, t327);
    let t329 = circuit_sub(in198, in13);
    let t330 = circuit_mul(in7, t329);
    let t331 = circuit_inverse(t330);
    let t332 = circuit_mul(in70, t331);
    let t333 = circuit_add(t326, t332);
    let t334 = circuit_sub(in198, in14);
    let t335 = circuit_mul(t328, t334);
    let t336 = circuit_sub(in198, in14);
    let t337 = circuit_mul(in8, t336);
    let t338 = circuit_inverse(t337);
    let t339 = circuit_mul(in71, t338);
    let t340 = circuit_add(t333, t339);
    let t341 = circuit_sub(in198, in15);
    let t342 = circuit_mul(t335, t341);
    let t343 = circuit_sub(in198, in15);
    let t344 = circuit_mul(in9, t343);
    let t345 = circuit_inverse(t344);
    let t346 = circuit_mul(in72, t345);
    let t347 = circuit_add(t340, t346);
    let t348 = circuit_sub(in198, in16);
    let t349 = circuit_mul(t342, t348);
    let t350 = circuit_sub(in198, in16);
    let t351 = circuit_mul(in10, t350);
    let t352 = circuit_inverse(t351);
    let t353 = circuit_mul(in73, t352);
    let t354 = circuit_add(t347, t353);
    let t355 = circuit_mul(t354, t349);
    let t356 = circuit_sub(in213, in0);
    let t357 = circuit_mul(in198, t356);
    let t358 = circuit_add(in0, t357);
    let t359 = circuit_mul(t293, t358);
    let t360 = circuit_add(in74, in75);
    let t361 = circuit_sub(t360, t355);
    let t362 = circuit_mul(t361, t298);
    let t363 = circuit_add(t297, t362);
    let t364 = circuit_mul(t298, in229);
    let t365 = circuit_sub(in199, in2);
    let t366 = circuit_mul(in0, t365);
    let t367 = circuit_sub(in199, in2);
    let t368 = circuit_mul(in3, t367);
    let t369 = circuit_inverse(t368);
    let t370 = circuit_mul(in74, t369);
    let t371 = circuit_add(in2, t370);
    let t372 = circuit_sub(in199, in0);
    let t373 = circuit_mul(t366, t372);
    let t374 = circuit_sub(in199, in0);
    let t375 = circuit_mul(in4, t374);
    let t376 = circuit_inverse(t375);
    let t377 = circuit_mul(in75, t376);
    let t378 = circuit_add(t371, t377);
    let t379 = circuit_sub(in199, in11);
    let t380 = circuit_mul(t373, t379);
    let t381 = circuit_sub(in199, in11);
    let t382 = circuit_mul(in5, t381);
    let t383 = circuit_inverse(t382);
    let t384 = circuit_mul(in76, t383);
    let t385 = circuit_add(t378, t384);
    let t386 = circuit_sub(in199, in12);
    let t387 = circuit_mul(t380, t386);
    let t388 = circuit_sub(in199, in12);
    let t389 = circuit_mul(in6, t388);
    let t390 = circuit_inverse(t389);
    let t391 = circuit_mul(in77, t390);
    let t392 = circuit_add(t385, t391);
    let t393 = circuit_sub(in199, in13);
    let t394 = circuit_mul(t387, t393);
    let t395 = circuit_sub(in199, in13);
    let t396 = circuit_mul(in7, t395);
    let t397 = circuit_inverse(t396);
    let t398 = circuit_mul(in78, t397);
    let t399 = circuit_add(t392, t398);
    let t400 = circuit_sub(in199, in14);
    let t401 = circuit_mul(t394, t400);
    let t402 = circuit_sub(in199, in14);
    let t403 = circuit_mul(in8, t402);
    let t404 = circuit_inverse(t403);
    let t405 = circuit_mul(in79, t404);
    let t406 = circuit_add(t399, t405);
    let t407 = circuit_sub(in199, in15);
    let t408 = circuit_mul(t401, t407);
    let t409 = circuit_sub(in199, in15);
    let t410 = circuit_mul(in9, t409);
    let t411 = circuit_inverse(t410);
    let t412 = circuit_mul(in80, t411);
    let t413 = circuit_add(t406, t412);
    let t414 = circuit_sub(in199, in16);
    let t415 = circuit_mul(t408, t414);
    let t416 = circuit_sub(in199, in16);
    let t417 = circuit_mul(in10, t416);
    let t418 = circuit_inverse(t417);
    let t419 = circuit_mul(in81, t418);
    let t420 = circuit_add(t413, t419);
    let t421 = circuit_mul(t420, t415);
    let t422 = circuit_sub(in214, in0);
    let t423 = circuit_mul(in199, t422);
    let t424 = circuit_add(in0, t423);
    let t425 = circuit_mul(t359, t424);
    let t426 = circuit_add(in82, in83);
    let t427 = circuit_sub(t426, t421);
    let t428 = circuit_mul(t427, t364);
    let t429 = circuit_add(t363, t428);
    let t430 = circuit_mul(t364, in229);
    let t431 = circuit_sub(in200, in2);
    let t432 = circuit_mul(in0, t431);
    let t433 = circuit_sub(in200, in2);
    let t434 = circuit_mul(in3, t433);
    let t435 = circuit_inverse(t434);
    let t436 = circuit_mul(in82, t435);
    let t437 = circuit_add(in2, t436);
    let t438 = circuit_sub(in200, in0);
    let t439 = circuit_mul(t432, t438);
    let t440 = circuit_sub(in200, in0);
    let t441 = circuit_mul(in4, t440);
    let t442 = circuit_inverse(t441);
    let t443 = circuit_mul(in83, t442);
    let t444 = circuit_add(t437, t443);
    let t445 = circuit_sub(in200, in11);
    let t446 = circuit_mul(t439, t445);
    let t447 = circuit_sub(in200, in11);
    let t448 = circuit_mul(in5, t447);
    let t449 = circuit_inverse(t448);
    let t450 = circuit_mul(in84, t449);
    let t451 = circuit_add(t444, t450);
    let t452 = circuit_sub(in200, in12);
    let t453 = circuit_mul(t446, t452);
    let t454 = circuit_sub(in200, in12);
    let t455 = circuit_mul(in6, t454);
    let t456 = circuit_inverse(t455);
    let t457 = circuit_mul(in85, t456);
    let t458 = circuit_add(t451, t457);
    let t459 = circuit_sub(in200, in13);
    let t460 = circuit_mul(t453, t459);
    let t461 = circuit_sub(in200, in13);
    let t462 = circuit_mul(in7, t461);
    let t463 = circuit_inverse(t462);
    let t464 = circuit_mul(in86, t463);
    let t465 = circuit_add(t458, t464);
    let t466 = circuit_sub(in200, in14);
    let t467 = circuit_mul(t460, t466);
    let t468 = circuit_sub(in200, in14);
    let t469 = circuit_mul(in8, t468);
    let t470 = circuit_inverse(t469);
    let t471 = circuit_mul(in87, t470);
    let t472 = circuit_add(t465, t471);
    let t473 = circuit_sub(in200, in15);
    let t474 = circuit_mul(t467, t473);
    let t475 = circuit_sub(in200, in15);
    let t476 = circuit_mul(in9, t475);
    let t477 = circuit_inverse(t476);
    let t478 = circuit_mul(in88, t477);
    let t479 = circuit_add(t472, t478);
    let t480 = circuit_sub(in200, in16);
    let t481 = circuit_mul(t474, t480);
    let t482 = circuit_sub(in200, in16);
    let t483 = circuit_mul(in10, t482);
    let t484 = circuit_inverse(t483);
    let t485 = circuit_mul(in89, t484);
    let t486 = circuit_add(t479, t485);
    let t487 = circuit_mul(t486, t481);
    let t488 = circuit_sub(in215, in0);
    let t489 = circuit_mul(in200, t488);
    let t490 = circuit_add(in0, t489);
    let t491 = circuit_mul(t425, t490);
    let t492 = circuit_add(in90, in91);
    let t493 = circuit_sub(t492, t487);
    let t494 = circuit_mul(t493, t430);
    let t495 = circuit_add(t429, t494);
    let t496 = circuit_mul(t430, in229);
    let t497 = circuit_sub(in201, in2);
    let t498 = circuit_mul(in0, t497);
    let t499 = circuit_sub(in201, in2);
    let t500 = circuit_mul(in3, t499);
    let t501 = circuit_inverse(t500);
    let t502 = circuit_mul(in90, t501);
    let t503 = circuit_add(in2, t502);
    let t504 = circuit_sub(in201, in0);
    let t505 = circuit_mul(t498, t504);
    let t506 = circuit_sub(in201, in0);
    let t507 = circuit_mul(in4, t506);
    let t508 = circuit_inverse(t507);
    let t509 = circuit_mul(in91, t508);
    let t510 = circuit_add(t503, t509);
    let t511 = circuit_sub(in201, in11);
    let t512 = circuit_mul(t505, t511);
    let t513 = circuit_sub(in201, in11);
    let t514 = circuit_mul(in5, t513);
    let t515 = circuit_inverse(t514);
    let t516 = circuit_mul(in92, t515);
    let t517 = circuit_add(t510, t516);
    let t518 = circuit_sub(in201, in12);
    let t519 = circuit_mul(t512, t518);
    let t520 = circuit_sub(in201, in12);
    let t521 = circuit_mul(in6, t520);
    let t522 = circuit_inverse(t521);
    let t523 = circuit_mul(in93, t522);
    let t524 = circuit_add(t517, t523);
    let t525 = circuit_sub(in201, in13);
    let t526 = circuit_mul(t519, t525);
    let t527 = circuit_sub(in201, in13);
    let t528 = circuit_mul(in7, t527);
    let t529 = circuit_inverse(t528);
    let t530 = circuit_mul(in94, t529);
    let t531 = circuit_add(t524, t530);
    let t532 = circuit_sub(in201, in14);
    let t533 = circuit_mul(t526, t532);
    let t534 = circuit_sub(in201, in14);
    let t535 = circuit_mul(in8, t534);
    let t536 = circuit_inverse(t535);
    let t537 = circuit_mul(in95, t536);
    let t538 = circuit_add(t531, t537);
    let t539 = circuit_sub(in201, in15);
    let t540 = circuit_mul(t533, t539);
    let t541 = circuit_sub(in201, in15);
    let t542 = circuit_mul(in9, t541);
    let t543 = circuit_inverse(t542);
    let t544 = circuit_mul(in96, t543);
    let t545 = circuit_add(t538, t544);
    let t546 = circuit_sub(in201, in16);
    let t547 = circuit_mul(t540, t546);
    let t548 = circuit_sub(in201, in16);
    let t549 = circuit_mul(in10, t548);
    let t550 = circuit_inverse(t549);
    let t551 = circuit_mul(in97, t550);
    let t552 = circuit_add(t545, t551);
    let t553 = circuit_mul(t552, t547);
    let t554 = circuit_sub(in216, in0);
    let t555 = circuit_mul(in201, t554);
    let t556 = circuit_add(in0, t555);
    let t557 = circuit_mul(t491, t556);
    let t558 = circuit_add(in98, in99);
    let t559 = circuit_sub(t558, t553);
    let t560 = circuit_mul(t559, t496);
    let t561 = circuit_add(t495, t560);
    let t562 = circuit_mul(t496, in229);
    let t563 = circuit_sub(in202, in2);
    let t564 = circuit_mul(in0, t563);
    let t565 = circuit_sub(in202, in2);
    let t566 = circuit_mul(in3, t565);
    let t567 = circuit_inverse(t566);
    let t568 = circuit_mul(in98, t567);
    let t569 = circuit_add(in2, t568);
    let t570 = circuit_sub(in202, in0);
    let t571 = circuit_mul(t564, t570);
    let t572 = circuit_sub(in202, in0);
    let t573 = circuit_mul(in4, t572);
    let t574 = circuit_inverse(t573);
    let t575 = circuit_mul(in99, t574);
    let t576 = circuit_add(t569, t575);
    let t577 = circuit_sub(in202, in11);
    let t578 = circuit_mul(t571, t577);
    let t579 = circuit_sub(in202, in11);
    let t580 = circuit_mul(in5, t579);
    let t581 = circuit_inverse(t580);
    let t582 = circuit_mul(in100, t581);
    let t583 = circuit_add(t576, t582);
    let t584 = circuit_sub(in202, in12);
    let t585 = circuit_mul(t578, t584);
    let t586 = circuit_sub(in202, in12);
    let t587 = circuit_mul(in6, t586);
    let t588 = circuit_inverse(t587);
    let t589 = circuit_mul(in101, t588);
    let t590 = circuit_add(t583, t589);
    let t591 = circuit_sub(in202, in13);
    let t592 = circuit_mul(t585, t591);
    let t593 = circuit_sub(in202, in13);
    let t594 = circuit_mul(in7, t593);
    let t595 = circuit_inverse(t594);
    let t596 = circuit_mul(in102, t595);
    let t597 = circuit_add(t590, t596);
    let t598 = circuit_sub(in202, in14);
    let t599 = circuit_mul(t592, t598);
    let t600 = circuit_sub(in202, in14);
    let t601 = circuit_mul(in8, t600);
    let t602 = circuit_inverse(t601);
    let t603 = circuit_mul(in103, t602);
    let t604 = circuit_add(t597, t603);
    let t605 = circuit_sub(in202, in15);
    let t606 = circuit_mul(t599, t605);
    let t607 = circuit_sub(in202, in15);
    let t608 = circuit_mul(in9, t607);
    let t609 = circuit_inverse(t608);
    let t610 = circuit_mul(in104, t609);
    let t611 = circuit_add(t604, t610);
    let t612 = circuit_sub(in202, in16);
    let t613 = circuit_mul(t606, t612);
    let t614 = circuit_sub(in202, in16);
    let t615 = circuit_mul(in10, t614);
    let t616 = circuit_inverse(t615);
    let t617 = circuit_mul(in105, t616);
    let t618 = circuit_add(t611, t617);
    let t619 = circuit_mul(t618, t613);
    let t620 = circuit_sub(in217, in0);
    let t621 = circuit_mul(in202, t620);
    let t622 = circuit_add(in0, t621);
    let t623 = circuit_mul(t557, t622);
    let t624 = circuit_add(in106, in107);
    let t625 = circuit_sub(t624, t619);
    let t626 = circuit_mul(t625, t562);
    let t627 = circuit_add(t561, t626);
    let t628 = circuit_mul(t562, in229);
    let t629 = circuit_sub(in203, in2);
    let t630 = circuit_mul(in0, t629);
    let t631 = circuit_sub(in203, in2);
    let t632 = circuit_mul(in3, t631);
    let t633 = circuit_inverse(t632);
    let t634 = circuit_mul(in106, t633);
    let t635 = circuit_add(in2, t634);
    let t636 = circuit_sub(in203, in0);
    let t637 = circuit_mul(t630, t636);
    let t638 = circuit_sub(in203, in0);
    let t639 = circuit_mul(in4, t638);
    let t640 = circuit_inverse(t639);
    let t641 = circuit_mul(in107, t640);
    let t642 = circuit_add(t635, t641);
    let t643 = circuit_sub(in203, in11);
    let t644 = circuit_mul(t637, t643);
    let t645 = circuit_sub(in203, in11);
    let t646 = circuit_mul(in5, t645);
    let t647 = circuit_inverse(t646);
    let t648 = circuit_mul(in108, t647);
    let t649 = circuit_add(t642, t648);
    let t650 = circuit_sub(in203, in12);
    let t651 = circuit_mul(t644, t650);
    let t652 = circuit_sub(in203, in12);
    let t653 = circuit_mul(in6, t652);
    let t654 = circuit_inverse(t653);
    let t655 = circuit_mul(in109, t654);
    let t656 = circuit_add(t649, t655);
    let t657 = circuit_sub(in203, in13);
    let t658 = circuit_mul(t651, t657);
    let t659 = circuit_sub(in203, in13);
    let t660 = circuit_mul(in7, t659);
    let t661 = circuit_inverse(t660);
    let t662 = circuit_mul(in110, t661);
    let t663 = circuit_add(t656, t662);
    let t664 = circuit_sub(in203, in14);
    let t665 = circuit_mul(t658, t664);
    let t666 = circuit_sub(in203, in14);
    let t667 = circuit_mul(in8, t666);
    let t668 = circuit_inverse(t667);
    let t669 = circuit_mul(in111, t668);
    let t670 = circuit_add(t663, t669);
    let t671 = circuit_sub(in203, in15);
    let t672 = circuit_mul(t665, t671);
    let t673 = circuit_sub(in203, in15);
    let t674 = circuit_mul(in9, t673);
    let t675 = circuit_inverse(t674);
    let t676 = circuit_mul(in112, t675);
    let t677 = circuit_add(t670, t676);
    let t678 = circuit_sub(in203, in16);
    let t679 = circuit_mul(t672, t678);
    let t680 = circuit_sub(in203, in16);
    let t681 = circuit_mul(in10, t680);
    let t682 = circuit_inverse(t681);
    let t683 = circuit_mul(in113, t682);
    let t684 = circuit_add(t677, t683);
    let t685 = circuit_mul(t684, t679);
    let t686 = circuit_sub(in218, in0);
    let t687 = circuit_mul(in203, t686);
    let t688 = circuit_add(in0, t687);
    let t689 = circuit_mul(t623, t688);
    let t690 = circuit_add(in114, in115);
    let t691 = circuit_sub(t690, t685);
    let t692 = circuit_mul(t691, t628);
    let t693 = circuit_add(t627, t692);
    let t694 = circuit_mul(t628, in229);
    let t695 = circuit_sub(in204, in2);
    let t696 = circuit_mul(in0, t695);
    let t697 = circuit_sub(in204, in2);
    let t698 = circuit_mul(in3, t697);
    let t699 = circuit_inverse(t698);
    let t700 = circuit_mul(in114, t699);
    let t701 = circuit_add(in2, t700);
    let t702 = circuit_sub(in204, in0);
    let t703 = circuit_mul(t696, t702);
    let t704 = circuit_sub(in204, in0);
    let t705 = circuit_mul(in4, t704);
    let t706 = circuit_inverse(t705);
    let t707 = circuit_mul(in115, t706);
    let t708 = circuit_add(t701, t707);
    let t709 = circuit_sub(in204, in11);
    let t710 = circuit_mul(t703, t709);
    let t711 = circuit_sub(in204, in11);
    let t712 = circuit_mul(in5, t711);
    let t713 = circuit_inverse(t712);
    let t714 = circuit_mul(in116, t713);
    let t715 = circuit_add(t708, t714);
    let t716 = circuit_sub(in204, in12);
    let t717 = circuit_mul(t710, t716);
    let t718 = circuit_sub(in204, in12);
    let t719 = circuit_mul(in6, t718);
    let t720 = circuit_inverse(t719);
    let t721 = circuit_mul(in117, t720);
    let t722 = circuit_add(t715, t721);
    let t723 = circuit_sub(in204, in13);
    let t724 = circuit_mul(t717, t723);
    let t725 = circuit_sub(in204, in13);
    let t726 = circuit_mul(in7, t725);
    let t727 = circuit_inverse(t726);
    let t728 = circuit_mul(in118, t727);
    let t729 = circuit_add(t722, t728);
    let t730 = circuit_sub(in204, in14);
    let t731 = circuit_mul(t724, t730);
    let t732 = circuit_sub(in204, in14);
    let t733 = circuit_mul(in8, t732);
    let t734 = circuit_inverse(t733);
    let t735 = circuit_mul(in119, t734);
    let t736 = circuit_add(t729, t735);
    let t737 = circuit_sub(in204, in15);
    let t738 = circuit_mul(t731, t737);
    let t739 = circuit_sub(in204, in15);
    let t740 = circuit_mul(in9, t739);
    let t741 = circuit_inverse(t740);
    let t742 = circuit_mul(in120, t741);
    let t743 = circuit_add(t736, t742);
    let t744 = circuit_sub(in204, in16);
    let t745 = circuit_mul(t738, t744);
    let t746 = circuit_sub(in204, in16);
    let t747 = circuit_mul(in10, t746);
    let t748 = circuit_inverse(t747);
    let t749 = circuit_mul(in121, t748);
    let t750 = circuit_add(t743, t749);
    let t751 = circuit_mul(t750, t745);
    let t752 = circuit_sub(in219, in0);
    let t753 = circuit_mul(in204, t752);
    let t754 = circuit_add(in0, t753);
    let t755 = circuit_mul(t689, t754);
    let t756 = circuit_add(in122, in123);
    let t757 = circuit_sub(t756, t751);
    let t758 = circuit_mul(t757, t694);
    let t759 = circuit_add(t693, t758);
    let t760 = circuit_mul(t694, in229);
    let t761 = circuit_sub(in205, in2);
    let t762 = circuit_mul(in0, t761);
    let t763 = circuit_sub(in205, in2);
    let t764 = circuit_mul(in3, t763);
    let t765 = circuit_inverse(t764);
    let t766 = circuit_mul(in122, t765);
    let t767 = circuit_add(in2, t766);
    let t768 = circuit_sub(in205, in0);
    let t769 = circuit_mul(t762, t768);
    let t770 = circuit_sub(in205, in0);
    let t771 = circuit_mul(in4, t770);
    let t772 = circuit_inverse(t771);
    let t773 = circuit_mul(in123, t772);
    let t774 = circuit_add(t767, t773);
    let t775 = circuit_sub(in205, in11);
    let t776 = circuit_mul(t769, t775);
    let t777 = circuit_sub(in205, in11);
    let t778 = circuit_mul(in5, t777);
    let t779 = circuit_inverse(t778);
    let t780 = circuit_mul(in124, t779);
    let t781 = circuit_add(t774, t780);
    let t782 = circuit_sub(in205, in12);
    let t783 = circuit_mul(t776, t782);
    let t784 = circuit_sub(in205, in12);
    let t785 = circuit_mul(in6, t784);
    let t786 = circuit_inverse(t785);
    let t787 = circuit_mul(in125, t786);
    let t788 = circuit_add(t781, t787);
    let t789 = circuit_sub(in205, in13);
    let t790 = circuit_mul(t783, t789);
    let t791 = circuit_sub(in205, in13);
    let t792 = circuit_mul(in7, t791);
    let t793 = circuit_inverse(t792);
    let t794 = circuit_mul(in126, t793);
    let t795 = circuit_add(t788, t794);
    let t796 = circuit_sub(in205, in14);
    let t797 = circuit_mul(t790, t796);
    let t798 = circuit_sub(in205, in14);
    let t799 = circuit_mul(in8, t798);
    let t800 = circuit_inverse(t799);
    let t801 = circuit_mul(in127, t800);
    let t802 = circuit_add(t795, t801);
    let t803 = circuit_sub(in205, in15);
    let t804 = circuit_mul(t797, t803);
    let t805 = circuit_sub(in205, in15);
    let t806 = circuit_mul(in9, t805);
    let t807 = circuit_inverse(t806);
    let t808 = circuit_mul(in128, t807);
    let t809 = circuit_add(t802, t808);
    let t810 = circuit_sub(in205, in16);
    let t811 = circuit_mul(t804, t810);
    let t812 = circuit_sub(in205, in16);
    let t813 = circuit_mul(in10, t812);
    let t814 = circuit_inverse(t813);
    let t815 = circuit_mul(in129, t814);
    let t816 = circuit_add(t809, t815);
    let t817 = circuit_mul(t816, t811);
    let t818 = circuit_sub(in220, in0);
    let t819 = circuit_mul(in205, t818);
    let t820 = circuit_add(in0, t819);
    let t821 = circuit_mul(t755, t820);
    let t822 = circuit_add(in130, in131);
    let t823 = circuit_sub(t822, t817);
    let t824 = circuit_mul(t823, t760);
    let t825 = circuit_add(t759, t824);
    let t826 = circuit_mul(t760, in229);
    let t827 = circuit_sub(in206, in2);
    let t828 = circuit_mul(in0, t827);
    let t829 = circuit_sub(in206, in2);
    let t830 = circuit_mul(in3, t829);
    let t831 = circuit_inverse(t830);
    let t832 = circuit_mul(in130, t831);
    let t833 = circuit_add(in2, t832);
    let t834 = circuit_sub(in206, in0);
    let t835 = circuit_mul(t828, t834);
    let t836 = circuit_sub(in206, in0);
    let t837 = circuit_mul(in4, t836);
    let t838 = circuit_inverse(t837);
    let t839 = circuit_mul(in131, t838);
    let t840 = circuit_add(t833, t839);
    let t841 = circuit_sub(in206, in11);
    let t842 = circuit_mul(t835, t841);
    let t843 = circuit_sub(in206, in11);
    let t844 = circuit_mul(in5, t843);
    let t845 = circuit_inverse(t844);
    let t846 = circuit_mul(in132, t845);
    let t847 = circuit_add(t840, t846);
    let t848 = circuit_sub(in206, in12);
    let t849 = circuit_mul(t842, t848);
    let t850 = circuit_sub(in206, in12);
    let t851 = circuit_mul(in6, t850);
    let t852 = circuit_inverse(t851);
    let t853 = circuit_mul(in133, t852);
    let t854 = circuit_add(t847, t853);
    let t855 = circuit_sub(in206, in13);
    let t856 = circuit_mul(t849, t855);
    let t857 = circuit_sub(in206, in13);
    let t858 = circuit_mul(in7, t857);
    let t859 = circuit_inverse(t858);
    let t860 = circuit_mul(in134, t859);
    let t861 = circuit_add(t854, t860);
    let t862 = circuit_sub(in206, in14);
    let t863 = circuit_mul(t856, t862);
    let t864 = circuit_sub(in206, in14);
    let t865 = circuit_mul(in8, t864);
    let t866 = circuit_inverse(t865);
    let t867 = circuit_mul(in135, t866);
    let t868 = circuit_add(t861, t867);
    let t869 = circuit_sub(in206, in15);
    let t870 = circuit_mul(t863, t869);
    let t871 = circuit_sub(in206, in15);
    let t872 = circuit_mul(in9, t871);
    let t873 = circuit_inverse(t872);
    let t874 = circuit_mul(in136, t873);
    let t875 = circuit_add(t868, t874);
    let t876 = circuit_sub(in206, in16);
    let t877 = circuit_mul(t870, t876);
    let t878 = circuit_sub(in206, in16);
    let t879 = circuit_mul(in10, t878);
    let t880 = circuit_inverse(t879);
    let t881 = circuit_mul(in137, t880);
    let t882 = circuit_add(t875, t881);
    let t883 = circuit_mul(t882, t877);
    let t884 = circuit_sub(in221, in0);
    let t885 = circuit_mul(in206, t884);
    let t886 = circuit_add(in0, t885);
    let t887 = circuit_mul(t821, t886);
    let t888 = circuit_add(in138, in139);
    let t889 = circuit_sub(t888, t883);
    let t890 = circuit_mul(t889, t826);
    let t891 = circuit_add(t825, t890);
    let t892 = circuit_mul(t826, in229);
    let t893 = circuit_sub(in207, in2);
    let t894 = circuit_mul(in0, t893);
    let t895 = circuit_sub(in207, in2);
    let t896 = circuit_mul(in3, t895);
    let t897 = circuit_inverse(t896);
    let t898 = circuit_mul(in138, t897);
    let t899 = circuit_add(in2, t898);
    let t900 = circuit_sub(in207, in0);
    let t901 = circuit_mul(t894, t900);
    let t902 = circuit_sub(in207, in0);
    let t903 = circuit_mul(in4, t902);
    let t904 = circuit_inverse(t903);
    let t905 = circuit_mul(in139, t904);
    let t906 = circuit_add(t899, t905);
    let t907 = circuit_sub(in207, in11);
    let t908 = circuit_mul(t901, t907);
    let t909 = circuit_sub(in207, in11);
    let t910 = circuit_mul(in5, t909);
    let t911 = circuit_inverse(t910);
    let t912 = circuit_mul(in140, t911);
    let t913 = circuit_add(t906, t912);
    let t914 = circuit_sub(in207, in12);
    let t915 = circuit_mul(t908, t914);
    let t916 = circuit_sub(in207, in12);
    let t917 = circuit_mul(in6, t916);
    let t918 = circuit_inverse(t917);
    let t919 = circuit_mul(in141, t918);
    let t920 = circuit_add(t913, t919);
    let t921 = circuit_sub(in207, in13);
    let t922 = circuit_mul(t915, t921);
    let t923 = circuit_sub(in207, in13);
    let t924 = circuit_mul(in7, t923);
    let t925 = circuit_inverse(t924);
    let t926 = circuit_mul(in142, t925);
    let t927 = circuit_add(t920, t926);
    let t928 = circuit_sub(in207, in14);
    let t929 = circuit_mul(t922, t928);
    let t930 = circuit_sub(in207, in14);
    let t931 = circuit_mul(in8, t930);
    let t932 = circuit_inverse(t931);
    let t933 = circuit_mul(in143, t932);
    let t934 = circuit_add(t927, t933);
    let t935 = circuit_sub(in207, in15);
    let t936 = circuit_mul(t929, t935);
    let t937 = circuit_sub(in207, in15);
    let t938 = circuit_mul(in9, t937);
    let t939 = circuit_inverse(t938);
    let t940 = circuit_mul(in144, t939);
    let t941 = circuit_add(t934, t940);
    let t942 = circuit_sub(in207, in16);
    let t943 = circuit_mul(t936, t942);
    let t944 = circuit_sub(in207, in16);
    let t945 = circuit_mul(in10, t944);
    let t946 = circuit_inverse(t945);
    let t947 = circuit_mul(in145, t946);
    let t948 = circuit_add(t941, t947);
    let t949 = circuit_mul(t948, t943);
    let t950 = circuit_sub(in222, in0);
    let t951 = circuit_mul(in207, t950);
    let t952 = circuit_add(in0, t951);
    let t953 = circuit_mul(t887, t952);
    let t954 = circuit_add(in146, in147);
    let t955 = circuit_sub(t954, t949);
    let t956 = circuit_mul(t955, t892);
    let t957 = circuit_add(t891, t956);
    let t958 = circuit_sub(in208, in2);
    let t959 = circuit_mul(in0, t958);
    let t960 = circuit_sub(in208, in2);
    let t961 = circuit_mul(in3, t960);
    let t962 = circuit_inverse(t961);
    let t963 = circuit_mul(in146, t962);
    let t964 = circuit_add(in2, t963);
    let t965 = circuit_sub(in208, in0);
    let t966 = circuit_mul(t959, t965);
    let t967 = circuit_sub(in208, in0);
    let t968 = circuit_mul(in4, t967);
    let t969 = circuit_inverse(t968);
    let t970 = circuit_mul(in147, t969);
    let t971 = circuit_add(t964, t970);
    let t972 = circuit_sub(in208, in11);
    let t973 = circuit_mul(t966, t972);
    let t974 = circuit_sub(in208, in11);
    let t975 = circuit_mul(in5, t974);
    let t976 = circuit_inverse(t975);
    let t977 = circuit_mul(in148, t976);
    let t978 = circuit_add(t971, t977);
    let t979 = circuit_sub(in208, in12);
    let t980 = circuit_mul(t973, t979);
    let t981 = circuit_sub(in208, in12);
    let t982 = circuit_mul(in6, t981);
    let t983 = circuit_inverse(t982);
    let t984 = circuit_mul(in149, t983);
    let t985 = circuit_add(t978, t984);
    let t986 = circuit_sub(in208, in13);
    let t987 = circuit_mul(t980, t986);
    let t988 = circuit_sub(in208, in13);
    let t989 = circuit_mul(in7, t988);
    let t990 = circuit_inverse(t989);
    let t991 = circuit_mul(in150, t990);
    let t992 = circuit_add(t985, t991);
    let t993 = circuit_sub(in208, in14);
    let t994 = circuit_mul(t987, t993);
    let t995 = circuit_sub(in208, in14);
    let t996 = circuit_mul(in8, t995);
    let t997 = circuit_inverse(t996);
    let t998 = circuit_mul(in151, t997);
    let t999 = circuit_add(t992, t998);
    let t1000 = circuit_sub(in208, in15);
    let t1001 = circuit_mul(t994, t1000);
    let t1002 = circuit_sub(in208, in15);
    let t1003 = circuit_mul(in9, t1002);
    let t1004 = circuit_inverse(t1003);
    let t1005 = circuit_mul(in152, t1004);
    let t1006 = circuit_add(t999, t1005);
    let t1007 = circuit_sub(in208, in16);
    let t1008 = circuit_mul(t1001, t1007);
    let t1009 = circuit_sub(in208, in16);
    let t1010 = circuit_mul(in10, t1009);
    let t1011 = circuit_inverse(t1010);
    let t1012 = circuit_mul(in153, t1011);
    let t1013 = circuit_add(t1006, t1012);
    let t1014 = circuit_mul(t1013, t1008);
    let t1015 = circuit_sub(in223, in0);
    let t1016 = circuit_mul(in208, t1015);
    let t1017 = circuit_add(in0, t1016);
    let t1018 = circuit_mul(t953, t1017);
    let t1019 = circuit_sub(in161, in12);
    let t1020 = circuit_mul(t1019, in154);
    let t1021 = circuit_mul(t1020, in182);
    let t1022 = circuit_mul(t1021, in181);
    let t1023 = circuit_mul(t1022, in17);
    let t1024 = circuit_mul(in156, in181);
    let t1025 = circuit_mul(in157, in182);
    let t1026 = circuit_mul(in158, in183);
    let t1027 = circuit_mul(in159, in184);
    let t1028 = circuit_add(t1023, t1024);
    let t1029 = circuit_add(t1028, t1025);
    let t1030 = circuit_add(t1029, t1026);
    let t1031 = circuit_add(t1030, t1027);
    let t1032 = circuit_add(t1031, in155);
    let t1033 = circuit_sub(in161, in0);
    let t1034 = circuit_mul(t1033, in192);
    let t1035 = circuit_add(t1032, t1034);
    let t1036 = circuit_mul(t1035, in161);
    let t1037 = circuit_mul(t1036, t1018);
    let t1038 = circuit_add(in181, in184);
    let t1039 = circuit_add(t1038, in154);
    let t1040 = circuit_sub(t1039, in189);
    let t1041 = circuit_sub(in161, in11);
    let t1042 = circuit_mul(t1040, t1041);
    let t1043 = circuit_sub(in161, in0);
    let t1044 = circuit_mul(t1042, t1043);
    let t1045 = circuit_mul(t1044, in161);
    let t1046 = circuit_mul(t1045, t1018);
    let t1047 = circuit_mul(in171, in227);
    let t1048 = circuit_add(in181, t1047);
    let t1049 = circuit_add(t1048, in228);
    let t1050 = circuit_mul(in172, in227);
    let t1051 = circuit_add(in182, t1050);
    let t1052 = circuit_add(t1051, in228);
    let t1053 = circuit_mul(t1049, t1052);
    let t1054 = circuit_mul(in173, in227);
    let t1055 = circuit_add(in183, t1054);
    let t1056 = circuit_add(t1055, in228);
    let t1057 = circuit_mul(t1053, t1056);
    let t1058 = circuit_mul(in174, in227);
    let t1059 = circuit_add(in184, t1058);
    let t1060 = circuit_add(t1059, in228);
    let t1061 = circuit_mul(t1057, t1060);
    let t1062 = circuit_mul(in167, in227);
    let t1063 = circuit_add(in181, t1062);
    let t1064 = circuit_add(t1063, in228);
    let t1065 = circuit_mul(in168, in227);
    let t1066 = circuit_add(in182, t1065);
    let t1067 = circuit_add(t1066, in228);
    let t1068 = circuit_mul(t1064, t1067);
    let t1069 = circuit_mul(in169, in227);
    let t1070 = circuit_add(in183, t1069);
    let t1071 = circuit_add(t1070, in228);
    let t1072 = circuit_mul(t1068, t1071);
    let t1073 = circuit_mul(in170, in227);
    let t1074 = circuit_add(in184, t1073);
    let t1075 = circuit_add(t1074, in228);
    let t1076 = circuit_mul(t1072, t1075);
    let t1077 = circuit_add(in185, in179);
    let t1078 = circuit_mul(t1061, t1077);
    let t1079 = circuit_mul(in180, t29);
    let t1080 = circuit_add(in193, t1079);
    let t1081 = circuit_mul(t1076, t1080);
    let t1082 = circuit_sub(t1078, t1081);
    let t1083 = circuit_mul(t1082, t1018);
    let t1084 = circuit_mul(in180, in193);
    let t1085 = circuit_mul(t1084, t1018);
    let t1086 = circuit_mul(in176, in224);
    let t1087 = circuit_mul(in177, in225);
    let t1088 = circuit_mul(in178, in226);
    let t1089 = circuit_add(in175, in228);
    let t1090 = circuit_add(t1089, t1086);
    let t1091 = circuit_add(t1090, t1087);
    let t1092 = circuit_add(t1091, t1088);
    let t1093 = circuit_mul(in157, in189);
    let t1094 = circuit_add(in181, in228);
    let t1095 = circuit_add(t1094, t1093);
    let t1096 = circuit_mul(in154, in190);
    let t1097 = circuit_add(in182, t1096);
    let t1098 = circuit_mul(in155, in191);
    let t1099 = circuit_add(in183, t1098);
    let t1100 = circuit_mul(t1097, in224);
    let t1101 = circuit_mul(t1099, in225);
    let t1102 = circuit_mul(in158, in226);
    let t1103 = circuit_add(t1095, t1100);
    let t1104 = circuit_add(t1103, t1101);
    let t1105 = circuit_add(t1104, t1102);
    let t1106 = circuit_mul(in186, t1092);
    let t1107 = circuit_mul(in186, t1105);
    let t1108 = circuit_add(in188, in160);
    let t1109 = circuit_mul(in188, in160);
    let t1110 = circuit_sub(t1108, t1109);
    let t1111 = circuit_mul(t1105, t1092);
    let t1112 = circuit_mul(t1111, in186);
    let t1113 = circuit_sub(t1112, t1110);
    let t1114 = circuit_mul(t1113, t1018);
    let t1115 = circuit_mul(in160, t1106);
    let t1116 = circuit_mul(in187, t1107);
    let t1117 = circuit_sub(t1115, t1116);
    let t1118 = circuit_sub(in182, in181);
    let t1119 = circuit_sub(in183, in182);
    let t1120 = circuit_sub(in184, in183);
    let t1121 = circuit_sub(in189, in184);
    let t1122 = circuit_add(t1118, in18);
    let t1123 = circuit_add(t1118, in19);
    let t1124 = circuit_add(t1118, in20);
    let t1125 = circuit_mul(t1118, t1122);
    let t1126 = circuit_mul(t1125, t1123);
    let t1127 = circuit_mul(t1126, t1124);
    let t1128 = circuit_mul(t1127, in162);
    let t1129 = circuit_mul(t1128, t1018);
    let t1130 = circuit_add(t1119, in18);
    let t1131 = circuit_add(t1119, in19);
    let t1132 = circuit_add(t1119, in20);
    let t1133 = circuit_mul(t1119, t1130);
    let t1134 = circuit_mul(t1133, t1131);
    let t1135 = circuit_mul(t1134, t1132);
    let t1136 = circuit_mul(t1135, in162);
    let t1137 = circuit_mul(t1136, t1018);
    let t1138 = circuit_add(t1120, in18);
    let t1139 = circuit_add(t1120, in19);
    let t1140 = circuit_add(t1120, in20);
    let t1141 = circuit_mul(t1120, t1138);
    let t1142 = circuit_mul(t1141, t1139);
    let t1143 = circuit_mul(t1142, t1140);
    let t1144 = circuit_mul(t1143, in162);
    let t1145 = circuit_mul(t1144, t1018);
    let t1146 = circuit_add(t1121, in18);
    let t1147 = circuit_add(t1121, in19);
    let t1148 = circuit_add(t1121, in20);
    let t1149 = circuit_mul(t1121, t1146);
    let t1150 = circuit_mul(t1149, t1147);
    let t1151 = circuit_mul(t1150, t1148);
    let t1152 = circuit_mul(t1151, in162);
    let t1153 = circuit_mul(t1152, t1018);
    let t1154 = circuit_sub(in189, in182);
    let t1155 = circuit_mul(in183, in183);
    let t1156 = circuit_mul(in192, in192);
    let t1157 = circuit_mul(in183, in192);
    let t1158 = circuit_mul(t1157, in156);
    let t1159 = circuit_add(in190, in189);
    let t1160 = circuit_add(t1159, in182);
    let t1161 = circuit_mul(t1160, t1154);
    let t1162 = circuit_mul(t1161, t1154);
    let t1163 = circuit_sub(t1162, t1156);
    let t1164 = circuit_sub(t1163, t1155);
    let t1165 = circuit_add(t1164, t1158);
    let t1166 = circuit_add(t1165, t1158);
    let t1167 = circuit_sub(in0, in154);
    let t1168 = circuit_mul(t1166, t1018);
    let t1169 = circuit_mul(t1168, in163);
    let t1170 = circuit_mul(t1169, t1167);
    let t1171 = circuit_add(in183, in191);
    let t1172 = circuit_mul(in192, in156);
    let t1173 = circuit_sub(t1172, in183);
    let t1174 = circuit_mul(t1171, t1154);
    let t1175 = circuit_sub(in190, in182);
    let t1176 = circuit_mul(t1175, t1173);
    let t1177 = circuit_add(t1174, t1176);
    let t1178 = circuit_mul(t1177, t1018);
    let t1179 = circuit_mul(t1178, in163);
    let t1180 = circuit_mul(t1179, t1167);
    let t1181 = circuit_add(t1155, in21);
    let t1182 = circuit_mul(t1181, in182);
    let t1183 = circuit_add(t1155, t1155);
    let t1184 = circuit_add(t1183, t1183);
    let t1185 = circuit_mul(t1182, in22);
    let t1186 = circuit_add(in190, in182);
    let t1187 = circuit_add(t1186, in182);
    let t1188 = circuit_mul(t1187, t1184);
    let t1189 = circuit_sub(t1188, t1185);
    let t1190 = circuit_mul(t1189, t1018);
    let t1191 = circuit_mul(t1190, in163);
    let t1192 = circuit_mul(t1191, in154);
    let t1193 = circuit_add(t1170, t1192);
    let t1194 = circuit_add(in182, in182);
    let t1195 = circuit_add(t1194, in182);
    let t1196 = circuit_mul(t1195, in182);
    let t1197 = circuit_sub(in182, in190);
    let t1198 = circuit_mul(t1196, t1197);
    let t1199 = circuit_add(in183, in183);
    let t1200 = circuit_add(in183, in191);
    let t1201 = circuit_mul(t1199, t1200);
    let t1202 = circuit_sub(t1198, t1201);
    let t1203 = circuit_mul(t1202, t1018);
    let t1204 = circuit_mul(t1203, in163);
    let t1205 = circuit_mul(t1204, in154);
    let t1206 = circuit_add(t1180, t1205);
    let t1207 = circuit_mul(in181, in190);
    let t1208 = circuit_mul(in189, in182);
    let t1209 = circuit_add(t1207, t1208);
    let t1210 = circuit_mul(in181, in184);
    let t1211 = circuit_mul(in182, in183);
    let t1212 = circuit_add(t1210, t1211);
    let t1213 = circuit_sub(t1212, in191);
    let t1214 = circuit_mul(t1213, in23);
    let t1215 = circuit_sub(t1214, in192);
    let t1216 = circuit_add(t1215, t1209);
    let t1217 = circuit_mul(t1216, in159);
    let t1218 = circuit_mul(t1209, in23);
    let t1219 = circuit_mul(in189, in190);
    let t1220 = circuit_add(t1218, t1219);
    let t1221 = circuit_add(in183, in184);
    let t1222 = circuit_sub(t1220, t1221);
    let t1223 = circuit_mul(t1222, in158);
    let t1224 = circuit_add(t1220, in184);
    let t1225 = circuit_add(in191, in192);
    let t1226 = circuit_sub(t1224, t1225);
    let t1227 = circuit_mul(t1226, in154);
    let t1228 = circuit_add(t1223, t1217);
    let t1229 = circuit_add(t1228, t1227);
    let t1230 = circuit_mul(t1229, in157);
    let t1231 = circuit_mul(in190, in24);
    let t1232 = circuit_add(t1231, in189);
    let t1233 = circuit_mul(t1232, in24);
    let t1234 = circuit_add(t1233, in183);
    let t1235 = circuit_mul(t1234, in24);
    let t1236 = circuit_add(t1235, in182);
    let t1237 = circuit_mul(t1236, in24);
    let t1238 = circuit_add(t1237, in181);
    let t1239 = circuit_sub(t1238, in184);
    let t1240 = circuit_mul(t1239, in159);
    let t1241 = circuit_mul(in191, in24);
    let t1242 = circuit_add(t1241, in190);
    let t1243 = circuit_mul(t1242, in24);
    let t1244 = circuit_add(t1243, in189);
    let t1245 = circuit_mul(t1244, in24);
    let t1246 = circuit_add(t1245, in184);
    let t1247 = circuit_mul(t1246, in24);
    let t1248 = circuit_add(t1247, in183);
    let t1249 = circuit_sub(t1248, in192);
    let t1250 = circuit_mul(t1249, in154);
    let t1251 = circuit_add(t1240, t1250);
    let t1252 = circuit_mul(t1251, in158);
    let t1253 = circuit_mul(in183, in226);
    let t1254 = circuit_mul(in182, in225);
    let t1255 = circuit_mul(in181, in224);
    let t1256 = circuit_add(t1253, t1254);
    let t1257 = circuit_add(t1256, t1255);
    let t1258 = circuit_add(t1257, in155);
    let t1259 = circuit_sub(t1258, in184);
    let t1260 = circuit_sub(in189, in181);
    let t1261 = circuit_sub(in192, in184);
    let t1262 = circuit_mul(t1260, t1260);
    let t1263 = circuit_sub(t1262, t1260);
    let t1264 = circuit_sub(in2, t1260);
    let t1265 = circuit_add(t1264, in0);
    let t1266 = circuit_mul(t1265, t1261);
    let t1267 = circuit_mul(in156, in157);
    let t1268 = circuit_mul(t1267, in164);
    let t1269 = circuit_mul(t1268, t1018);
    let t1270 = circuit_mul(t1266, t1269);
    let t1271 = circuit_mul(t1263, t1269);
    let t1272 = circuit_mul(t1259, t1267);
    let t1273 = circuit_sub(in184, t1258);
    let t1274 = circuit_mul(t1273, t1273);
    let t1275 = circuit_sub(t1274, t1273);
    let t1276 = circuit_mul(in191, in226);
    let t1277 = circuit_mul(in190, in225);
    let t1278 = circuit_mul(in189, in224);
    let t1279 = circuit_add(t1276, t1277);
    let t1280 = circuit_add(t1279, t1278);
    let t1281 = circuit_sub(in192, t1280);
    let t1282 = circuit_sub(in191, in183);
    let t1283 = circuit_sub(in2, t1260);
    let t1284 = circuit_add(t1283, in0);
    let t1285 = circuit_sub(in2, t1281);
    let t1286 = circuit_add(t1285, in0);
    let t1287 = circuit_mul(t1282, t1286);
    let t1288 = circuit_mul(t1284, t1287);
    let t1289 = circuit_mul(t1281, t1281);
    let t1290 = circuit_sub(t1289, t1281);
    let t1291 = circuit_mul(in161, in164);
    let t1292 = circuit_mul(t1291, t1018);
    let t1293 = circuit_mul(t1288, t1292);
    let t1294 = circuit_mul(t1263, t1292);
    let t1295 = circuit_mul(t1290, t1292);
    let t1296 = circuit_mul(t1275, in161);
    let t1297 = circuit_sub(in190, in182);
    let t1298 = circuit_sub(in2, t1260);
    let t1299 = circuit_add(t1298, in0);
    let t1300 = circuit_mul(t1299, t1297);
    let t1301 = circuit_sub(t1300, in183);
    let t1302 = circuit_mul(t1301, in159);
    let t1303 = circuit_mul(t1302, in156);
    let t1304 = circuit_add(t1272, t1303);
    let t1305 = circuit_mul(t1259, in154);
    let t1306 = circuit_mul(t1305, in156);
    let t1307 = circuit_add(t1304, t1306);
    let t1308 = circuit_add(t1307, t1296);
    let t1309 = circuit_add(t1308, t1230);
    let t1310 = circuit_add(t1309, t1252);
    let t1311 = circuit_mul(t1310, in164);
    let t1312 = circuit_mul(t1311, t1018);
    let t1313 = circuit_add(in181, in156);
    let t1314 = circuit_add(in182, in157);
    let t1315 = circuit_add(in183, in158);
    let t1316 = circuit_add(in184, in159);
    let t1317 = circuit_mul(t1313, t1313);
    let t1318 = circuit_mul(t1317, t1317);
    let t1319 = circuit_mul(t1318, t1313);
    let t1320 = circuit_mul(t1314, t1314);
    let t1321 = circuit_mul(t1320, t1320);
    let t1322 = circuit_mul(t1321, t1314);
    let t1323 = circuit_mul(t1315, t1315);
    let t1324 = circuit_mul(t1323, t1323);
    let t1325 = circuit_mul(t1324, t1315);
    let t1326 = circuit_mul(t1316, t1316);
    let t1327 = circuit_mul(t1326, t1326);
    let t1328 = circuit_mul(t1327, t1316);
    let t1329 = circuit_add(t1319, t1322);
    let t1330 = circuit_add(t1325, t1328);
    let t1331 = circuit_add(t1322, t1322);
    let t1332 = circuit_add(t1331, t1330);
    let t1333 = circuit_add(t1328, t1328);
    let t1334 = circuit_add(t1333, t1329);
    let t1335 = circuit_add(t1330, t1330);
    let t1336 = circuit_add(t1335, t1335);
    let t1337 = circuit_add(t1336, t1334);
    let t1338 = circuit_add(t1329, t1329);
    let t1339 = circuit_add(t1338, t1338);
    let t1340 = circuit_add(t1339, t1332);
    let t1341 = circuit_add(t1334, t1340);
    let t1342 = circuit_add(t1332, t1337);
    let t1343 = circuit_mul(in165, t1018);
    let t1344 = circuit_sub(t1341, in189);
    let t1345 = circuit_mul(t1343, t1344);
    let t1346 = circuit_sub(t1340, in190);
    let t1347 = circuit_mul(t1343, t1346);
    let t1348 = circuit_sub(t1342, in191);
    let t1349 = circuit_mul(t1343, t1348);
    let t1350 = circuit_sub(t1337, in192);
    let t1351 = circuit_mul(t1343, t1350);
    let t1352 = circuit_add(in181, in156);
    let t1353 = circuit_mul(t1352, t1352);
    let t1354 = circuit_mul(t1353, t1353);
    let t1355 = circuit_mul(t1354, t1352);
    let t1356 = circuit_add(t1355, in182);
    let t1357 = circuit_add(t1356, in183);
    let t1358 = circuit_add(t1357, in184);
    let t1359 = circuit_mul(in166, t1018);
    let t1360 = circuit_mul(t1355, in25);
    let t1361 = circuit_add(t1360, t1358);
    let t1362 = circuit_sub(t1361, in189);
    let t1363 = circuit_mul(t1359, t1362);
    let t1364 = circuit_mul(in182, in26);
    let t1365 = circuit_add(t1364, t1358);
    let t1366 = circuit_sub(t1365, in190);
    let t1367 = circuit_mul(t1359, t1366);
    let t1368 = circuit_mul(in183, in27);
    let t1369 = circuit_add(t1368, t1358);
    let t1370 = circuit_sub(t1369, in191);
    let t1371 = circuit_mul(t1359, t1370);
    let t1372 = circuit_mul(in184, in28);
    let t1373 = circuit_add(t1372, t1358);
    let t1374 = circuit_sub(t1373, in192);
    let t1375 = circuit_mul(t1359, t1374);
    let t1376 = circuit_mul(t1046, in230);
    let t1377 = circuit_add(t1037, t1376);
    let t1378 = circuit_mul(t1083, in231);
    let t1379 = circuit_add(t1377, t1378);
    let t1380 = circuit_mul(t1085, in232);
    let t1381 = circuit_add(t1379, t1380);
    let t1382 = circuit_mul(t1114, in233);
    let t1383 = circuit_add(t1381, t1382);
    let t1384 = circuit_mul(t1117, in234);
    let t1385 = circuit_add(t1383, t1384);
    let t1386 = circuit_mul(t1129, in235);
    let t1387 = circuit_add(t1385, t1386);
    let t1388 = circuit_mul(t1137, in236);
    let t1389 = circuit_add(t1387, t1388);
    let t1390 = circuit_mul(t1145, in237);
    let t1391 = circuit_add(t1389, t1390);
    let t1392 = circuit_mul(t1153, in238);
    let t1393 = circuit_add(t1391, t1392);
    let t1394 = circuit_mul(t1193, in239);
    let t1395 = circuit_add(t1393, t1394);
    let t1396 = circuit_mul(t1206, in240);
    let t1397 = circuit_add(t1395, t1396);
    let t1398 = circuit_mul(t1312, in241);
    let t1399 = circuit_add(t1397, t1398);
    let t1400 = circuit_mul(t1270, in242);
    let t1401 = circuit_add(t1399, t1400);
    let t1402 = circuit_mul(t1271, in243);
    let t1403 = circuit_add(t1401, t1402);
    let t1404 = circuit_mul(t1293, in244);
    let t1405 = circuit_add(t1403, t1404);
    let t1406 = circuit_mul(t1294, in245);
    let t1407 = circuit_add(t1405, t1406);
    let t1408 = circuit_mul(t1295, in246);
    let t1409 = circuit_add(t1407, t1408);
    let t1410 = circuit_mul(t1345, in247);
    let t1411 = circuit_add(t1409, t1410);
    let t1412 = circuit_mul(t1347, in248);
    let t1413 = circuit_add(t1411, t1412);
    let t1414 = circuit_mul(t1349, in249);
    let t1415 = circuit_add(t1413, t1414);
    let t1416 = circuit_mul(t1351, in250);
    let t1417 = circuit_add(t1415, t1416);
    let t1418 = circuit_mul(t1363, in251);
    let t1419 = circuit_add(t1417, t1418);
    let t1420 = circuit_mul(t1367, in252);
    let t1421 = circuit_add(t1419, t1420);
    let t1422 = circuit_mul(t1371, in253);
    let t1423 = circuit_add(t1421, t1422);
    let t1424 = circuit_mul(t1375, in254);
    let t1425 = circuit_add(t1423, t1424);
    let t1426 = circuit_sub(t1425, t1014);

    let modulus = get_GRUMPKIN_modulus(); // GRUMPKIN prime field modulus

    let mut circuit_inputs = (t957, t1426).new_inputs();
    // Prefill constants:

    circuit_inputs = circuit_inputs
        .next_span(HONK_SUMCHECK_SIZE_15_PUB_4_GRUMPKIN_CONSTANTS.span()); // in0 - in28

    // Fill inputs:

    for val in p_public_inputs {
        circuit_inputs = circuit_inputs.next_u256(*val);
    } // in29 - in32

    circuit_inputs = circuit_inputs.next_2(p_public_inputs_offset); // in33

    for val in sumcheck_univariates_flat {
        circuit_inputs = circuit_inputs.next_u256(*val);
    } // in34 - in153

    for val in sumcheck_evaluations {
        circuit_inputs = circuit_inputs.next_u256(*val);
    } // in154 - in193

    for val in tp_sum_check_u_challenges {
        circuit_inputs = circuit_inputs.next_u128(*val);
    } // in194 - in208

    for val in tp_gate_challenges {
        circuit_inputs = circuit_inputs.next_u128(*val);
    } // in209 - in223

    circuit_inputs = circuit_inputs.next_u128(tp_eta_1); // in224
    circuit_inputs = circuit_inputs.next_u128(tp_eta_2); // in225
    circuit_inputs = circuit_inputs.next_u128(tp_eta_3); // in226
    circuit_inputs = circuit_inputs.next_u128(tp_beta); // in227
    circuit_inputs = circuit_inputs.next_u128(tp_gamma); // in228
    circuit_inputs = circuit_inputs.next_2(tp_base_rlc); // in229

    for val in tp_alphas {
        circuit_inputs = circuit_inputs.next_u128(*val);
    } // in230 - in254

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let check_rlc: u384 = outputs.get_output(t957);
    let check: u384 = outputs.get_output(t1426);
    return (check_rlc, check);
}
const HONK_SUMCHECK_SIZE_15_PUB_4_GRUMPKIN_CONSTANTS: [u384; 29] = [
    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x8000, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 {
        limb0: 0x79b9709143e1f593efffec51,
        limb1: 0xb85045b68181585d2833e848,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
    u384 { limb0: 0x2d0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 {
        limb0: 0x79b9709143e1f593efffff11,
        limb1: 0xb85045b68181585d2833e848,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
    u384 { limb0: 0x90, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 {
        limb0: 0x79b9709143e1f593efffff71,
        limb1: 0xb85045b68181585d2833e848,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
    u384 { limb0: 0xf0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 {
        limb0: 0x79b9709143e1f593effffd31,
        limb1: 0xb85045b68181585d2833e848,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
    u384 { limb0: 0x13b0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x2, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x3, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x4, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x5, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x6, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x7, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 {
        limb0: 0x3cdcb848a1f0fac9f8000000,
        limb1: 0xdc2822db40c0ac2e9419f424,
        limb2: 0x183227397098d014,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x79b9709143e1f593f0000000,
        limb1: 0xb85045b68181585d2833e848,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x79b9709143e1f593efffffff,
        limb1: 0xb85045b68181585d2833e848,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x79b9709143e1f593effffffe,
        limb1: 0xb85045b68181585d2833e848,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
    u384 { limb0: 0x11, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x9, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x100000000000000000, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x4000, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 {
        limb0: 0x29ca1d7fb56821fd19d3b6e7,
        limb1: 0x4b1e03b4bd9490c0d03f989,
        limb2: 0x10dc6e9c006ea38b,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xd4dd9b84a86b38cfb45a740b,
        limb1: 0x149b3d0a30b3bb599df9756,
        limb2: 0xc28145b6a44df3e,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x60e3596170067d00141cac15,
        limb1: 0xb2c7645a50392798b21f75bb,
        limb2: 0x544b8338791518,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xb8fa852613bc534433ee428b,
        limb1: 0x2e2e82eb122789e352e105a3,
        limb2: 0x222c01175718386f,
        limb3: 0x0,
    },
];
#[inline(always)]
pub fn run_GRUMPKIN_HONK_PREP_MSM_SCALARS_SIZE_15_circuit(
    p_sumcheck_evaluations: Span<u256>,
    p_gemini_a_evaluations: Span<u256>,
    tp_gemini_r: u384,
    tp_rho: u384,
    tp_shplonk_z: u384,
    tp_shplonk_nu: u384,
    tp_sum_check_u_challenges: Span<u128>,
) -> (
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0
    let in1 = CE::<CI<1>> {}; // 0x1

    // INPUT stack
    let (in2, in3, in4) = (CE::<CI<2>> {}, CE::<CI<3>> {}, CE::<CI<4>> {});
    let (in5, in6, in7) = (CE::<CI<5>> {}, CE::<CI<6>> {}, CE::<CI<7>> {});
    let (in8, in9, in10) = (CE::<CI<8>> {}, CE::<CI<9>> {}, CE::<CI<10>> {});
    let (in11, in12, in13) = (CE::<CI<11>> {}, CE::<CI<12>> {}, CE::<CI<13>> {});
    let (in14, in15, in16) = (CE::<CI<14>> {}, CE::<CI<15>> {}, CE::<CI<16>> {});
    let (in17, in18, in19) = (CE::<CI<17>> {}, CE::<CI<18>> {}, CE::<CI<19>> {});
    let (in20, in21, in22) = (CE::<CI<20>> {}, CE::<CI<21>> {}, CE::<CI<22>> {});
    let (in23, in24, in25) = (CE::<CI<23>> {}, CE::<CI<24>> {}, CE::<CI<25>> {});
    let (in26, in27, in28) = (CE::<CI<26>> {}, CE::<CI<27>> {}, CE::<CI<28>> {});
    let (in29, in30, in31) = (CE::<CI<29>> {}, CE::<CI<30>> {}, CE::<CI<31>> {});
    let (in32, in33, in34) = (CE::<CI<32>> {}, CE::<CI<33>> {}, CE::<CI<34>> {});
    let (in35, in36, in37) = (CE::<CI<35>> {}, CE::<CI<36>> {}, CE::<CI<37>> {});
    let (in38, in39, in40) = (CE::<CI<38>> {}, CE::<CI<39>> {}, CE::<CI<40>> {});
    let (in41, in42, in43) = (CE::<CI<41>> {}, CE::<CI<42>> {}, CE::<CI<43>> {});
    let (in44, in45, in46) = (CE::<CI<44>> {}, CE::<CI<45>> {}, CE::<CI<46>> {});
    let (in47, in48, in49) = (CE::<CI<47>> {}, CE::<CI<48>> {}, CE::<CI<49>> {});
    let (in50, in51, in52) = (CE::<CI<50>> {}, CE::<CI<51>> {}, CE::<CI<52>> {});
    let (in53, in54, in55) = (CE::<CI<53>> {}, CE::<CI<54>> {}, CE::<CI<55>> {});
    let (in56, in57, in58) = (CE::<CI<56>> {}, CE::<CI<57>> {}, CE::<CI<58>> {});
    let (in59, in60, in61) = (CE::<CI<59>> {}, CE::<CI<60>> {}, CE::<CI<61>> {});
    let (in62, in63, in64) = (CE::<CI<62>> {}, CE::<CI<63>> {}, CE::<CI<64>> {});
    let (in65, in66, in67) = (CE::<CI<65>> {}, CE::<CI<66>> {}, CE::<CI<67>> {});
    let (in68, in69, in70) = (CE::<CI<68>> {}, CE::<CI<69>> {}, CE::<CI<70>> {});
    let (in71, in72, in73) = (CE::<CI<71>> {}, CE::<CI<72>> {}, CE::<CI<73>> {});
    let (in74, in75) = (CE::<CI<74>> {}, CE::<CI<75>> {});
    let t0 = circuit_mul(in57, in57);
    let t1 = circuit_mul(t0, t0);
    let t2 = circuit_mul(t1, t1);
    let t3 = circuit_mul(t2, t2);
    let t4 = circuit_mul(t3, t3);
    let t5 = circuit_mul(t4, t4);
    let t6 = circuit_mul(t5, t5);
    let t7 = circuit_mul(t6, t6);
    let t8 = circuit_mul(t7, t7);
    let t9 = circuit_mul(t8, t8);
    let t10 = circuit_mul(t9, t9);
    let t11 = circuit_mul(t10, t10);
    let t12 = circuit_mul(t11, t11);
    let t13 = circuit_mul(t12, t12);
    let t14 = circuit_sub(in59, in57);
    let t15 = circuit_inverse(t14);
    let t16 = circuit_add(in59, in57);
    let t17 = circuit_inverse(t16);
    let t18 = circuit_mul(in60, t17);
    let t19 = circuit_add(t15, t18);
    let t20 = circuit_sub(in0, t19);
    let t21 = circuit_inverse(in57);
    let t22 = circuit_mul(in60, t17);
    let t23 = circuit_sub(t15, t22);
    let t24 = circuit_mul(t21, t23);
    let t25 = circuit_sub(in0, t24);
    let t26 = circuit_mul(t20, in1);
    let t27 = circuit_mul(in2, in1);
    let t28 = circuit_add(in0, t27);
    let t29 = circuit_mul(in1, in58);
    let t30 = circuit_mul(t20, t29);
    let t31 = circuit_mul(in3, t29);
    let t32 = circuit_add(t28, t31);
    let t33 = circuit_mul(t29, in58);
    let t34 = circuit_mul(t20, t33);
    let t35 = circuit_mul(in4, t33);
    let t36 = circuit_add(t32, t35);
    let t37 = circuit_mul(t33, in58);
    let t38 = circuit_mul(t20, t37);
    let t39 = circuit_mul(in5, t37);
    let t40 = circuit_add(t36, t39);
    let t41 = circuit_mul(t37, in58);
    let t42 = circuit_mul(t20, t41);
    let t43 = circuit_mul(in6, t41);
    let t44 = circuit_add(t40, t43);
    let t45 = circuit_mul(t41, in58);
    let t46 = circuit_mul(t20, t45);
    let t47 = circuit_mul(in7, t45);
    let t48 = circuit_add(t44, t47);
    let t49 = circuit_mul(t45, in58);
    let t50 = circuit_mul(t20, t49);
    let t51 = circuit_mul(in8, t49);
    let t52 = circuit_add(t48, t51);
    let t53 = circuit_mul(t49, in58);
    let t54 = circuit_mul(t20, t53);
    let t55 = circuit_mul(in9, t53);
    let t56 = circuit_add(t52, t55);
    let t57 = circuit_mul(t53, in58);
    let t58 = circuit_mul(t20, t57);
    let t59 = circuit_mul(in10, t57);
    let t60 = circuit_add(t56, t59);
    let t61 = circuit_mul(t57, in58);
    let t62 = circuit_mul(t20, t61);
    let t63 = circuit_mul(in11, t61);
    let t64 = circuit_add(t60, t63);
    let t65 = circuit_mul(t61, in58);
    let t66 = circuit_mul(t20, t65);
    let t67 = circuit_mul(in12, t65);
    let t68 = circuit_add(t64, t67);
    let t69 = circuit_mul(t65, in58);
    let t70 = circuit_mul(t20, t69);
    let t71 = circuit_mul(in13, t69);
    let t72 = circuit_add(t68, t71);
    let t73 = circuit_mul(t69, in58);
    let t74 = circuit_mul(t20, t73);
    let t75 = circuit_mul(in14, t73);
    let t76 = circuit_add(t72, t75);
    let t77 = circuit_mul(t73, in58);
    let t78 = circuit_mul(t20, t77);
    let t79 = circuit_mul(in15, t77);
    let t80 = circuit_add(t76, t79);
    let t81 = circuit_mul(t77, in58);
    let t82 = circuit_mul(t20, t81);
    let t83 = circuit_mul(in16, t81);
    let t84 = circuit_add(t80, t83);
    let t85 = circuit_mul(t81, in58);
    let t86 = circuit_mul(t20, t85);
    let t87 = circuit_mul(in17, t85);
    let t88 = circuit_add(t84, t87);
    let t89 = circuit_mul(t85, in58);
    let t90 = circuit_mul(t20, t89);
    let t91 = circuit_mul(in18, t89);
    let t92 = circuit_add(t88, t91);
    let t93 = circuit_mul(t89, in58);
    let t94 = circuit_mul(t20, t93);
    let t95 = circuit_mul(in19, t93);
    let t96 = circuit_add(t92, t95);
    let t97 = circuit_mul(t93, in58);
    let t98 = circuit_mul(t20, t97);
    let t99 = circuit_mul(in20, t97);
    let t100 = circuit_add(t96, t99);
    let t101 = circuit_mul(t97, in58);
    let t102 = circuit_mul(t20, t101);
    let t103 = circuit_mul(in21, t101);
    let t104 = circuit_add(t100, t103);
    let t105 = circuit_mul(t101, in58);
    let t106 = circuit_mul(t20, t105);
    let t107 = circuit_mul(in22, t105);
    let t108 = circuit_add(t104, t107);
    let t109 = circuit_mul(t105, in58);
    let t110 = circuit_mul(t20, t109);
    let t111 = circuit_mul(in23, t109);
    let t112 = circuit_add(t108, t111);
    let t113 = circuit_mul(t109, in58);
    let t114 = circuit_mul(t20, t113);
    let t115 = circuit_mul(in24, t113);
    let t116 = circuit_add(t112, t115);
    let t117 = circuit_mul(t113, in58);
    let t118 = circuit_mul(t20, t117);
    let t119 = circuit_mul(in25, t117);
    let t120 = circuit_add(t116, t119);
    let t121 = circuit_mul(t117, in58);
    let t122 = circuit_mul(t20, t121);
    let t123 = circuit_mul(in26, t121);
    let t124 = circuit_add(t120, t123);
    let t125 = circuit_mul(t121, in58);
    let t126 = circuit_mul(t20, t125);
    let t127 = circuit_mul(in27, t125);
    let t128 = circuit_add(t124, t127);
    let t129 = circuit_mul(t125, in58);
    let t130 = circuit_mul(t20, t129);
    let t131 = circuit_mul(in28, t129);
    let t132 = circuit_add(t128, t131);
    let t133 = circuit_mul(t129, in58);
    let t134 = circuit_mul(t20, t133);
    let t135 = circuit_mul(in29, t133);
    let t136 = circuit_add(t132, t135);
    let t137 = circuit_mul(t133, in58);
    let t138 = circuit_mul(t20, t137);
    let t139 = circuit_mul(in30, t137);
    let t140 = circuit_add(t136, t139);
    let t141 = circuit_mul(t137, in58);
    let t142 = circuit_mul(t20, t141);
    let t143 = circuit_mul(in31, t141);
    let t144 = circuit_add(t140, t143);
    let t145 = circuit_mul(t141, in58);
    let t146 = circuit_mul(t20, t145);
    let t147 = circuit_mul(in32, t145);
    let t148 = circuit_add(t144, t147);
    let t149 = circuit_mul(t145, in58);
    let t150 = circuit_mul(t20, t149);
    let t151 = circuit_mul(in33, t149);
    let t152 = circuit_add(t148, t151);
    let t153 = circuit_mul(t149, in58);
    let t154 = circuit_mul(t20, t153);
    let t155 = circuit_mul(in34, t153);
    let t156 = circuit_add(t152, t155);
    let t157 = circuit_mul(t153, in58);
    let t158 = circuit_mul(t20, t157);
    let t159 = circuit_mul(in35, t157);
    let t160 = circuit_add(t156, t159);
    let t161 = circuit_mul(t157, in58);
    let t162 = circuit_mul(t20, t161);
    let t163 = circuit_mul(in36, t161);
    let t164 = circuit_add(t160, t163);
    let t165 = circuit_mul(t161, in58);
    let t166 = circuit_mul(t25, t165);
    let t167 = circuit_mul(in37, t165);
    let t168 = circuit_add(t164, t167);
    let t169 = circuit_mul(t165, in58);
    let t170 = circuit_mul(t25, t169);
    let t171 = circuit_mul(in38, t169);
    let t172 = circuit_add(t168, t171);
    let t173 = circuit_mul(t169, in58);
    let t174 = circuit_mul(t25, t173);
    let t175 = circuit_mul(in39, t173);
    let t176 = circuit_add(t172, t175);
    let t177 = circuit_mul(t173, in58);
    let t178 = circuit_mul(t25, t177);
    let t179 = circuit_mul(in40, t177);
    let t180 = circuit_add(t176, t179);
    let t181 = circuit_mul(t177, in58);
    let t182 = circuit_mul(t25, t181);
    let t183 = circuit_mul(in41, t181);
    let t184 = circuit_add(t180, t183);
    let t185 = circuit_sub(in1, in75);
    let t186 = circuit_mul(t13, t185);
    let t187 = circuit_mul(t13, t184);
    let t188 = circuit_add(t187, t187);
    let t189 = circuit_sub(t186, in75);
    let t190 = circuit_mul(in56, t189);
    let t191 = circuit_sub(t188, t190);
    let t192 = circuit_add(t186, in75);
    let t193 = circuit_inverse(t192);
    let t194 = circuit_mul(t191, t193);
    let t195 = circuit_sub(in1, in74);
    let t196 = circuit_mul(t12, t195);
    let t197 = circuit_mul(t12, t194);
    let t198 = circuit_add(t197, t197);
    let t199 = circuit_sub(t196, in74);
    let t200 = circuit_mul(in55, t199);
    let t201 = circuit_sub(t198, t200);
    let t202 = circuit_add(t196, in74);
    let t203 = circuit_inverse(t202);
    let t204 = circuit_mul(t201, t203);
    let t205 = circuit_sub(in1, in73);
    let t206 = circuit_mul(t11, t205);
    let t207 = circuit_mul(t11, t204);
    let t208 = circuit_add(t207, t207);
    let t209 = circuit_sub(t206, in73);
    let t210 = circuit_mul(in54, t209);
    let t211 = circuit_sub(t208, t210);
    let t212 = circuit_add(t206, in73);
    let t213 = circuit_inverse(t212);
    let t214 = circuit_mul(t211, t213);
    let t215 = circuit_sub(in1, in72);
    let t216 = circuit_mul(t10, t215);
    let t217 = circuit_mul(t10, t214);
    let t218 = circuit_add(t217, t217);
    let t219 = circuit_sub(t216, in72);
    let t220 = circuit_mul(in53, t219);
    let t221 = circuit_sub(t218, t220);
    let t222 = circuit_add(t216, in72);
    let t223 = circuit_inverse(t222);
    let t224 = circuit_mul(t221, t223);
    let t225 = circuit_sub(in1, in71);
    let t226 = circuit_mul(t9, t225);
    let t227 = circuit_mul(t9, t224);
    let t228 = circuit_add(t227, t227);
    let t229 = circuit_sub(t226, in71);
    let t230 = circuit_mul(in52, t229);
    let t231 = circuit_sub(t228, t230);
    let t232 = circuit_add(t226, in71);
    let t233 = circuit_inverse(t232);
    let t234 = circuit_mul(t231, t233);
    let t235 = circuit_sub(in1, in70);
    let t236 = circuit_mul(t8, t235);
    let t237 = circuit_mul(t8, t234);
    let t238 = circuit_add(t237, t237);
    let t239 = circuit_sub(t236, in70);
    let t240 = circuit_mul(in51, t239);
    let t241 = circuit_sub(t238, t240);
    let t242 = circuit_add(t236, in70);
    let t243 = circuit_inverse(t242);
    let t244 = circuit_mul(t241, t243);
    let t245 = circuit_sub(in1, in69);
    let t246 = circuit_mul(t7, t245);
    let t247 = circuit_mul(t7, t244);
    let t248 = circuit_add(t247, t247);
    let t249 = circuit_sub(t246, in69);
    let t250 = circuit_mul(in50, t249);
    let t251 = circuit_sub(t248, t250);
    let t252 = circuit_add(t246, in69);
    let t253 = circuit_inverse(t252);
    let t254 = circuit_mul(t251, t253);
    let t255 = circuit_sub(in1, in68);
    let t256 = circuit_mul(t6, t255);
    let t257 = circuit_mul(t6, t254);
    let t258 = circuit_add(t257, t257);
    let t259 = circuit_sub(t256, in68);
    let t260 = circuit_mul(in49, t259);
    let t261 = circuit_sub(t258, t260);
    let t262 = circuit_add(t256, in68);
    let t263 = circuit_inverse(t262);
    let t264 = circuit_mul(t261, t263);
    let t265 = circuit_sub(in1, in67);
    let t266 = circuit_mul(t5, t265);
    let t267 = circuit_mul(t5, t264);
    let t268 = circuit_add(t267, t267);
    let t269 = circuit_sub(t266, in67);
    let t270 = circuit_mul(in48, t269);
    let t271 = circuit_sub(t268, t270);
    let t272 = circuit_add(t266, in67);
    let t273 = circuit_inverse(t272);
    let t274 = circuit_mul(t271, t273);
    let t275 = circuit_sub(in1, in66);
    let t276 = circuit_mul(t4, t275);
    let t277 = circuit_mul(t4, t274);
    let t278 = circuit_add(t277, t277);
    let t279 = circuit_sub(t276, in66);
    let t280 = circuit_mul(in47, t279);
    let t281 = circuit_sub(t278, t280);
    let t282 = circuit_add(t276, in66);
    let t283 = circuit_inverse(t282);
    let t284 = circuit_mul(t281, t283);
    let t285 = circuit_sub(in1, in65);
    let t286 = circuit_mul(t3, t285);
    let t287 = circuit_mul(t3, t284);
    let t288 = circuit_add(t287, t287);
    let t289 = circuit_sub(t286, in65);
    let t290 = circuit_mul(in46, t289);
    let t291 = circuit_sub(t288, t290);
    let t292 = circuit_add(t286, in65);
    let t293 = circuit_inverse(t292);
    let t294 = circuit_mul(t291, t293);
    let t295 = circuit_sub(in1, in64);
    let t296 = circuit_mul(t2, t295);
    let t297 = circuit_mul(t2, t294);
    let t298 = circuit_add(t297, t297);
    let t299 = circuit_sub(t296, in64);
    let t300 = circuit_mul(in45, t299);
    let t301 = circuit_sub(t298, t300);
    let t302 = circuit_add(t296, in64);
    let t303 = circuit_inverse(t302);
    let t304 = circuit_mul(t301, t303);
    let t305 = circuit_sub(in1, in63);
    let t306 = circuit_mul(t1, t305);
    let t307 = circuit_mul(t1, t304);
    let t308 = circuit_add(t307, t307);
    let t309 = circuit_sub(t306, in63);
    let t310 = circuit_mul(in44, t309);
    let t311 = circuit_sub(t308, t310);
    let t312 = circuit_add(t306, in63);
    let t313 = circuit_inverse(t312);
    let t314 = circuit_mul(t311, t313);
    let t315 = circuit_sub(in1, in62);
    let t316 = circuit_mul(t0, t315);
    let t317 = circuit_mul(t0, t314);
    let t318 = circuit_add(t317, t317);
    let t319 = circuit_sub(t316, in62);
    let t320 = circuit_mul(in43, t319);
    let t321 = circuit_sub(t318, t320);
    let t322 = circuit_add(t316, in62);
    let t323 = circuit_inverse(t322);
    let t324 = circuit_mul(t321, t323);
    let t325 = circuit_sub(in1, in61);
    let t326 = circuit_mul(in57, t325);
    let t327 = circuit_mul(in57, t324);
    let t328 = circuit_add(t327, t327);
    let t329 = circuit_sub(t326, in61);
    let t330 = circuit_mul(in42, t329);
    let t331 = circuit_sub(t328, t330);
    let t332 = circuit_add(t326, in61);
    let t333 = circuit_inverse(t332);
    let t334 = circuit_mul(t331, t333);
    let t335 = circuit_mul(t334, t15);
    let t336 = circuit_mul(in42, in60);
    let t337 = circuit_mul(t336, t17);
    let t338 = circuit_add(t335, t337);
    let t339 = circuit_mul(in60, in60);
    let t340 = circuit_sub(in59, t0);
    let t341 = circuit_inverse(t340);
    let t342 = circuit_add(in59, t0);
    let t343 = circuit_inverse(t342);
    let t344 = circuit_mul(t339, t341);
    let t345 = circuit_mul(in60, t343);
    let t346 = circuit_mul(t339, t345);
    let t347 = circuit_add(t346, t344);
    let t348 = circuit_sub(in0, t347);
    let t349 = circuit_mul(t346, in43);
    let t350 = circuit_mul(t344, t324);
    let t351 = circuit_add(t349, t350);
    let t352 = circuit_add(t338, t351);
    let t353 = circuit_mul(in60, in60);
    let t354 = circuit_mul(t339, t353);
    let t355 = circuit_sub(in59, t1);
    let t356 = circuit_inverse(t355);
    let t357 = circuit_add(in59, t1);
    let t358 = circuit_inverse(t357);
    let t359 = circuit_mul(t354, t356);
    let t360 = circuit_mul(in60, t358);
    let t361 = circuit_mul(t354, t360);
    let t362 = circuit_add(t361, t359);
    let t363 = circuit_sub(in0, t362);
    let t364 = circuit_mul(t361, in44);
    let t365 = circuit_mul(t359, t314);
    let t366 = circuit_add(t364, t365);
    let t367 = circuit_add(t352, t366);
    let t368 = circuit_mul(in60, in60);
    let t369 = circuit_mul(t354, t368);
    let t370 = circuit_sub(in59, t2);
    let t371 = circuit_inverse(t370);
    let t372 = circuit_add(in59, t2);
    let t373 = circuit_inverse(t372);
    let t374 = circuit_mul(t369, t371);
    let t375 = circuit_mul(in60, t373);
    let t376 = circuit_mul(t369, t375);
    let t377 = circuit_add(t376, t374);
    let t378 = circuit_sub(in0, t377);
    let t379 = circuit_mul(t376, in45);
    let t380 = circuit_mul(t374, t304);
    let t381 = circuit_add(t379, t380);
    let t382 = circuit_add(t367, t381);
    let t383 = circuit_mul(in60, in60);
    let t384 = circuit_mul(t369, t383);
    let t385 = circuit_sub(in59, t3);
    let t386 = circuit_inverse(t385);
    let t387 = circuit_add(in59, t3);
    let t388 = circuit_inverse(t387);
    let t389 = circuit_mul(t384, t386);
    let t390 = circuit_mul(in60, t388);
    let t391 = circuit_mul(t384, t390);
    let t392 = circuit_add(t391, t389);
    let t393 = circuit_sub(in0, t392);
    let t394 = circuit_mul(t391, in46);
    let t395 = circuit_mul(t389, t294);
    let t396 = circuit_add(t394, t395);
    let t397 = circuit_add(t382, t396);
    let t398 = circuit_mul(in60, in60);
    let t399 = circuit_mul(t384, t398);
    let t400 = circuit_sub(in59, t4);
    let t401 = circuit_inverse(t400);
    let t402 = circuit_add(in59, t4);
    let t403 = circuit_inverse(t402);
    let t404 = circuit_mul(t399, t401);
    let t405 = circuit_mul(in60, t403);
    let t406 = circuit_mul(t399, t405);
    let t407 = circuit_add(t406, t404);
    let t408 = circuit_sub(in0, t407);
    let t409 = circuit_mul(t406, in47);
    let t410 = circuit_mul(t404, t284);
    let t411 = circuit_add(t409, t410);
    let t412 = circuit_add(t397, t411);
    let t413 = circuit_mul(in60, in60);
    let t414 = circuit_mul(t399, t413);
    let t415 = circuit_sub(in59, t5);
    let t416 = circuit_inverse(t415);
    let t417 = circuit_add(in59, t5);
    let t418 = circuit_inverse(t417);
    let t419 = circuit_mul(t414, t416);
    let t420 = circuit_mul(in60, t418);
    let t421 = circuit_mul(t414, t420);
    let t422 = circuit_add(t421, t419);
    let t423 = circuit_sub(in0, t422);
    let t424 = circuit_mul(t421, in48);
    let t425 = circuit_mul(t419, t274);
    let t426 = circuit_add(t424, t425);
    let t427 = circuit_add(t412, t426);
    let t428 = circuit_mul(in60, in60);
    let t429 = circuit_mul(t414, t428);
    let t430 = circuit_sub(in59, t6);
    let t431 = circuit_inverse(t430);
    let t432 = circuit_add(in59, t6);
    let t433 = circuit_inverse(t432);
    let t434 = circuit_mul(t429, t431);
    let t435 = circuit_mul(in60, t433);
    let t436 = circuit_mul(t429, t435);
    let t437 = circuit_add(t436, t434);
    let t438 = circuit_sub(in0, t437);
    let t439 = circuit_mul(t436, in49);
    let t440 = circuit_mul(t434, t264);
    let t441 = circuit_add(t439, t440);
    let t442 = circuit_add(t427, t441);
    let t443 = circuit_mul(in60, in60);
    let t444 = circuit_mul(t429, t443);
    let t445 = circuit_sub(in59, t7);
    let t446 = circuit_inverse(t445);
    let t447 = circuit_add(in59, t7);
    let t448 = circuit_inverse(t447);
    let t449 = circuit_mul(t444, t446);
    let t450 = circuit_mul(in60, t448);
    let t451 = circuit_mul(t444, t450);
    let t452 = circuit_add(t451, t449);
    let t453 = circuit_sub(in0, t452);
    let t454 = circuit_mul(t451, in50);
    let t455 = circuit_mul(t449, t254);
    let t456 = circuit_add(t454, t455);
    let t457 = circuit_add(t442, t456);
    let t458 = circuit_mul(in60, in60);
    let t459 = circuit_mul(t444, t458);
    let t460 = circuit_sub(in59, t8);
    let t461 = circuit_inverse(t460);
    let t462 = circuit_add(in59, t8);
    let t463 = circuit_inverse(t462);
    let t464 = circuit_mul(t459, t461);
    let t465 = circuit_mul(in60, t463);
    let t466 = circuit_mul(t459, t465);
    let t467 = circuit_add(t466, t464);
    let t468 = circuit_sub(in0, t467);
    let t469 = circuit_mul(t466, in51);
    let t470 = circuit_mul(t464, t244);
    let t471 = circuit_add(t469, t470);
    let t472 = circuit_add(t457, t471);
    let t473 = circuit_mul(in60, in60);
    let t474 = circuit_mul(t459, t473);
    let t475 = circuit_sub(in59, t9);
    let t476 = circuit_inverse(t475);
    let t477 = circuit_add(in59, t9);
    let t478 = circuit_inverse(t477);
    let t479 = circuit_mul(t474, t476);
    let t480 = circuit_mul(in60, t478);
    let t481 = circuit_mul(t474, t480);
    let t482 = circuit_add(t481, t479);
    let t483 = circuit_sub(in0, t482);
    let t484 = circuit_mul(t481, in52);
    let t485 = circuit_mul(t479, t234);
    let t486 = circuit_add(t484, t485);
    let t487 = circuit_add(t472, t486);
    let t488 = circuit_mul(in60, in60);
    let t489 = circuit_mul(t474, t488);
    let t490 = circuit_sub(in59, t10);
    let t491 = circuit_inverse(t490);
    let t492 = circuit_add(in59, t10);
    let t493 = circuit_inverse(t492);
    let t494 = circuit_mul(t489, t491);
    let t495 = circuit_mul(in60, t493);
    let t496 = circuit_mul(t489, t495);
    let t497 = circuit_add(t496, t494);
    let t498 = circuit_sub(in0, t497);
    let t499 = circuit_mul(t496, in53);
    let t500 = circuit_mul(t494, t224);
    let t501 = circuit_add(t499, t500);
    let t502 = circuit_add(t487, t501);
    let t503 = circuit_mul(in60, in60);
    let t504 = circuit_mul(t489, t503);
    let t505 = circuit_sub(in59, t11);
    let t506 = circuit_inverse(t505);
    let t507 = circuit_add(in59, t11);
    let t508 = circuit_inverse(t507);
    let t509 = circuit_mul(t504, t506);
    let t510 = circuit_mul(in60, t508);
    let t511 = circuit_mul(t504, t510);
    let t512 = circuit_add(t511, t509);
    let t513 = circuit_sub(in0, t512);
    let t514 = circuit_mul(t511, in54);
    let t515 = circuit_mul(t509, t214);
    let t516 = circuit_add(t514, t515);
    let t517 = circuit_add(t502, t516);
    let t518 = circuit_mul(in60, in60);
    let t519 = circuit_mul(t504, t518);
    let t520 = circuit_sub(in59, t12);
    let t521 = circuit_inverse(t520);
    let t522 = circuit_add(in59, t12);
    let t523 = circuit_inverse(t522);
    let t524 = circuit_mul(t519, t521);
    let t525 = circuit_mul(in60, t523);
    let t526 = circuit_mul(t519, t525);
    let t527 = circuit_add(t526, t524);
    let t528 = circuit_sub(in0, t527);
    let t529 = circuit_mul(t526, in55);
    let t530 = circuit_mul(t524, t204);
    let t531 = circuit_add(t529, t530);
    let t532 = circuit_add(t517, t531);
    let t533 = circuit_mul(in60, in60);
    let t534 = circuit_mul(t519, t533);
    let t535 = circuit_sub(in59, t13);
    let t536 = circuit_inverse(t535);
    let t537 = circuit_add(in59, t13);
    let t538 = circuit_inverse(t537);
    let t539 = circuit_mul(t534, t536);
    let t540 = circuit_mul(in60, t538);
    let t541 = circuit_mul(t534, t540);
    let t542 = circuit_add(t541, t539);
    let t543 = circuit_sub(in0, t542);
    let t544 = circuit_mul(t541, in56);
    let t545 = circuit_mul(t539, t194);
    let t546 = circuit_add(t544, t545);
    let t547 = circuit_add(t532, t546);
    let t548 = circuit_add(t134, t166);
    let t549 = circuit_add(t138, t170);
    let t550 = circuit_add(t142, t174);
    let t551 = circuit_add(t146, t178);
    let t552 = circuit_add(t150, t182);

    let modulus = get_GRUMPKIN_modulus(); // GRUMPKIN prime field modulus

    let mut circuit_inputs = (
        t26,
        t30,
        t34,
        t38,
        t42,
        t46,
        t50,
        t54,
        t58,
        t62,
        t66,
        t70,
        t74,
        t78,
        t82,
        t86,
        t90,
        t94,
        t98,
        t102,
        t106,
        t110,
        t114,
        t118,
        t122,
        t126,
        t130,
        t548,
        t549,
        t550,
        t551,
        t552,
        t154,
        t158,
        t162,
        t348,
        t363,
        t378,
        t393,
        t408,
        t423,
        t438,
        t453,
        t468,
        t483,
        t498,
        t513,
        t528,
        t543,
        t547,
    )
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs.next_2([0x1, 0x0, 0x0, 0x0]); // in1
    // Fill inputs:

    for val in p_sumcheck_evaluations {
        circuit_inputs = circuit_inputs.next_u256(*val);
    } // in2 - in41

    for val in p_gemini_a_evaluations {
        circuit_inputs = circuit_inputs.next_u256(*val);
    } // in42 - in56

    circuit_inputs = circuit_inputs.next_2(tp_gemini_r); // in57
    circuit_inputs = circuit_inputs.next_2(tp_rho); // in58
    circuit_inputs = circuit_inputs.next_2(tp_shplonk_z); // in59
    circuit_inputs = circuit_inputs.next_2(tp_shplonk_nu); // in60

    for val in tp_sum_check_u_challenges {
        circuit_inputs = circuit_inputs.next_u128(*val);
    } // in61 - in75

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let scalar_1: u384 = outputs.get_output(t26);
    let scalar_2: u384 = outputs.get_output(t30);
    let scalar_3: u384 = outputs.get_output(t34);
    let scalar_4: u384 = outputs.get_output(t38);
    let scalar_5: u384 = outputs.get_output(t42);
    let scalar_6: u384 = outputs.get_output(t46);
    let scalar_7: u384 = outputs.get_output(t50);
    let scalar_8: u384 = outputs.get_output(t54);
    let scalar_9: u384 = outputs.get_output(t58);
    let scalar_10: u384 = outputs.get_output(t62);
    let scalar_11: u384 = outputs.get_output(t66);
    let scalar_12: u384 = outputs.get_output(t70);
    let scalar_13: u384 = outputs.get_output(t74);
    let scalar_14: u384 = outputs.get_output(t78);
    let scalar_15: u384 = outputs.get_output(t82);
    let scalar_16: u384 = outputs.get_output(t86);
    let scalar_17: u384 = outputs.get_output(t90);
    let scalar_18: u384 = outputs.get_output(t94);
    let scalar_19: u384 = outputs.get_output(t98);
    let scalar_20: u384 = outputs.get_output(t102);
    let scalar_21: u384 = outputs.get_output(t106);
    let scalar_22: u384 = outputs.get_output(t110);
    let scalar_23: u384 = outputs.get_output(t114);
    let scalar_24: u384 = outputs.get_output(t118);
    let scalar_25: u384 = outputs.get_output(t122);
    let scalar_26: u384 = outputs.get_output(t126);
    let scalar_27: u384 = outputs.get_output(t130);
    let scalar_28: u384 = outputs.get_output(t548);
    let scalar_29: u384 = outputs.get_output(t549);
    let scalar_30: u384 = outputs.get_output(t550);
    let scalar_31: u384 = outputs.get_output(t551);
    let scalar_32: u384 = outputs.get_output(t552);
    let scalar_33: u384 = outputs.get_output(t154);
    let scalar_34: u384 = outputs.get_output(t158);
    let scalar_35: u384 = outputs.get_output(t162);
    let scalar_41: u384 = outputs.get_output(t348);
    let scalar_42: u384 = outputs.get_output(t363);
    let scalar_43: u384 = outputs.get_output(t378);
    let scalar_44: u384 = outputs.get_output(t393);
    let scalar_45: u384 = outputs.get_output(t408);
    let scalar_46: u384 = outputs.get_output(t423);
    let scalar_47: u384 = outputs.get_output(t438);
    let scalar_48: u384 = outputs.get_output(t453);
    let scalar_49: u384 = outputs.get_output(t468);
    let scalar_50: u384 = outputs.get_output(t483);
    let scalar_51: u384 = outputs.get_output(t498);
    let scalar_52: u384 = outputs.get_output(t513);
    let scalar_53: u384 = outputs.get_output(t528);
    let scalar_54: u384 = outputs.get_output(t543);
    let scalar_68: u384 = outputs.get_output(t547);
    return (
        scalar_1,
        scalar_2,
        scalar_3,
        scalar_4,
        scalar_5,
        scalar_6,
        scalar_7,
        scalar_8,
        scalar_9,
        scalar_10,
        scalar_11,
        scalar_12,
        scalar_13,
        scalar_14,
        scalar_15,
        scalar_16,
        scalar_17,
        scalar_18,
        scalar_19,
        scalar_20,
        scalar_21,
        scalar_22,
        scalar_23,
        scalar_24,
        scalar_25,
        scalar_26,
        scalar_27,
        scalar_28,
        scalar_29,
        scalar_30,
        scalar_31,
        scalar_32,
        scalar_33,
        scalar_34,
        scalar_35,
        scalar_41,
        scalar_42,
        scalar_43,
        scalar_44,
        scalar_45,
        scalar_46,
        scalar_47,
        scalar_48,
        scalar_49,
        scalar_50,
        scalar_51,
        scalar_52,
        scalar_53,
        scalar_54,
        scalar_68,
    );
}
pub fn run_BN254_EVAL_FN_CHALLENGE_SING_51P_RLC_circuit(
    A: G1Point, coeff: u384, SumDlogDivBatched: FunctionFelt,
) -> (u384,) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13, in14) = (CE::<CI<12>> {}, CE::<CI<13>> {}, CE::<CI<14>> {});
    let (in15, in16, in17) = (CE::<CI<15>> {}, CE::<CI<16>> {}, CE::<CI<17>> {});
    let (in18, in19, in20) = (CE::<CI<18>> {}, CE::<CI<19>> {}, CE::<CI<20>> {});
    let (in21, in22, in23) = (CE::<CI<21>> {}, CE::<CI<22>> {}, CE::<CI<23>> {});
    let (in24, in25, in26) = (CE::<CI<24>> {}, CE::<CI<25>> {}, CE::<CI<26>> {});
    let (in27, in28, in29) = (CE::<CI<27>> {}, CE::<CI<28>> {}, CE::<CI<29>> {});
    let (in30, in31, in32) = (CE::<CI<30>> {}, CE::<CI<31>> {}, CE::<CI<32>> {});
    let (in33, in34, in35) = (CE::<CI<33>> {}, CE::<CI<34>> {}, CE::<CI<35>> {});
    let (in36, in37, in38) = (CE::<CI<36>> {}, CE::<CI<37>> {}, CE::<CI<38>> {});
    let (in39, in40, in41) = (CE::<CI<39>> {}, CE::<CI<40>> {}, CE::<CI<41>> {});
    let (in42, in43, in44) = (CE::<CI<42>> {}, CE::<CI<43>> {}, CE::<CI<44>> {});
    let (in45, in46, in47) = (CE::<CI<45>> {}, CE::<CI<46>> {}, CE::<CI<47>> {});
    let (in48, in49, in50) = (CE::<CI<48>> {}, CE::<CI<49>> {}, CE::<CI<50>> {});
    let (in51, in52, in53) = (CE::<CI<51>> {}, CE::<CI<52>> {}, CE::<CI<53>> {});
    let (in54, in55, in56) = (CE::<CI<54>> {}, CE::<CI<55>> {}, CE::<CI<56>> {});
    let (in57, in58, in59) = (CE::<CI<57>> {}, CE::<CI<58>> {}, CE::<CI<59>> {});
    let (in60, in61, in62) = (CE::<CI<60>> {}, CE::<CI<61>> {}, CE::<CI<62>> {});
    let (in63, in64, in65) = (CE::<CI<63>> {}, CE::<CI<64>> {}, CE::<CI<65>> {});
    let (in66, in67, in68) = (CE::<CI<66>> {}, CE::<CI<67>> {}, CE::<CI<68>> {});
    let (in69, in70, in71) = (CE::<CI<69>> {}, CE::<CI<70>> {}, CE::<CI<71>> {});
    let (in72, in73, in74) = (CE::<CI<72>> {}, CE::<CI<73>> {}, CE::<CI<74>> {});
    let (in75, in76, in77) = (CE::<CI<75>> {}, CE::<CI<76>> {}, CE::<CI<77>> {});
    let (in78, in79, in80) = (CE::<CI<78>> {}, CE::<CI<79>> {}, CE::<CI<80>> {});
    let (in81, in82, in83) = (CE::<CI<81>> {}, CE::<CI<82>> {}, CE::<CI<83>> {});
    let (in84, in85, in86) = (CE::<CI<84>> {}, CE::<CI<85>> {}, CE::<CI<86>> {});
    let (in87, in88, in89) = (CE::<CI<87>> {}, CE::<CI<88>> {}, CE::<CI<89>> {});
    let (in90, in91, in92) = (CE::<CI<90>> {}, CE::<CI<91>> {}, CE::<CI<92>> {});
    let (in93, in94, in95) = (CE::<CI<93>> {}, CE::<CI<94>> {}, CE::<CI<95>> {});
    let (in96, in97, in98) = (CE::<CI<96>> {}, CE::<CI<97>> {}, CE::<CI<98>> {});
    let (in99, in100, in101) = (CE::<CI<99>> {}, CE::<CI<100>> {}, CE::<CI<101>> {});
    let (in102, in103, in104) = (CE::<CI<102>> {}, CE::<CI<103>> {}, CE::<CI<104>> {});
    let (in105, in106, in107) = (CE::<CI<105>> {}, CE::<CI<106>> {}, CE::<CI<107>> {});
    let (in108, in109, in110) = (CE::<CI<108>> {}, CE::<CI<109>> {}, CE::<CI<110>> {});
    let (in111, in112, in113) = (CE::<CI<111>> {}, CE::<CI<112>> {}, CE::<CI<113>> {});
    let (in114, in115, in116) = (CE::<CI<114>> {}, CE::<CI<115>> {}, CE::<CI<116>> {});
    let (in117, in118, in119) = (CE::<CI<117>> {}, CE::<CI<118>> {}, CE::<CI<119>> {});
    let (in120, in121, in122) = (CE::<CI<120>> {}, CE::<CI<121>> {}, CE::<CI<122>> {});
    let (in123, in124, in125) = (CE::<CI<123>> {}, CE::<CI<124>> {}, CE::<CI<125>> {});
    let (in126, in127, in128) = (CE::<CI<126>> {}, CE::<CI<127>> {}, CE::<CI<128>> {});
    let (in129, in130, in131) = (CE::<CI<129>> {}, CE::<CI<130>> {}, CE::<CI<131>> {});
    let (in132, in133, in134) = (CE::<CI<132>> {}, CE::<CI<133>> {}, CE::<CI<134>> {});
    let (in135, in136, in137) = (CE::<CI<135>> {}, CE::<CI<136>> {}, CE::<CI<137>> {});
    let (in138, in139, in140) = (CE::<CI<138>> {}, CE::<CI<139>> {}, CE::<CI<140>> {});
    let (in141, in142, in143) = (CE::<CI<141>> {}, CE::<CI<142>> {}, CE::<CI<143>> {});
    let (in144, in145, in146) = (CE::<CI<144>> {}, CE::<CI<145>> {}, CE::<CI<146>> {});
    let (in147, in148, in149) = (CE::<CI<147>> {}, CE::<CI<148>> {}, CE::<CI<149>> {});
    let (in150, in151, in152) = (CE::<CI<150>> {}, CE::<CI<151>> {}, CE::<CI<152>> {});
    let (in153, in154, in155) = (CE::<CI<153>> {}, CE::<CI<154>> {}, CE::<CI<155>> {});
    let (in156, in157, in158) = (CE::<CI<156>> {}, CE::<CI<157>> {}, CE::<CI<158>> {});
    let (in159, in160, in161) = (CE::<CI<159>> {}, CE::<CI<160>> {}, CE::<CI<161>> {});
    let (in162, in163, in164) = (CE::<CI<162>> {}, CE::<CI<163>> {}, CE::<CI<164>> {});
    let (in165, in166, in167) = (CE::<CI<165>> {}, CE::<CI<166>> {}, CE::<CI<167>> {});
    let (in168, in169, in170) = (CE::<CI<168>> {}, CE::<CI<169>> {}, CE::<CI<170>> {});
    let (in171, in172, in173) = (CE::<CI<171>> {}, CE::<CI<172>> {}, CE::<CI<173>> {});
    let (in174, in175, in176) = (CE::<CI<174>> {}, CE::<CI<175>> {}, CE::<CI<176>> {});
    let (in177, in178, in179) = (CE::<CI<177>> {}, CE::<CI<178>> {}, CE::<CI<179>> {});
    let (in180, in181, in182) = (CE::<CI<180>> {}, CE::<CI<181>> {}, CE::<CI<182>> {});
    let (in183, in184, in185) = (CE::<CI<183>> {}, CE::<CI<184>> {}, CE::<CI<185>> {});
    let (in186, in187, in188) = (CE::<CI<186>> {}, CE::<CI<187>> {}, CE::<CI<188>> {});
    let (in189, in190, in191) = (CE::<CI<189>> {}, CE::<CI<190>> {}, CE::<CI<191>> {});
    let (in192, in193, in194) = (CE::<CI<192>> {}, CE::<CI<193>> {}, CE::<CI<194>> {});
    let (in195, in196, in197) = (CE::<CI<195>> {}, CE::<CI<196>> {}, CE::<CI<197>> {});
    let (in198, in199, in200) = (CE::<CI<198>> {}, CE::<CI<199>> {}, CE::<CI<200>> {});
    let (in201, in202, in203) = (CE::<CI<201>> {}, CE::<CI<202>> {}, CE::<CI<203>> {});
    let (in204, in205, in206) = (CE::<CI<204>> {}, CE::<CI<205>> {}, CE::<CI<206>> {});
    let (in207, in208, in209) = (CE::<CI<207>> {}, CE::<CI<208>> {}, CE::<CI<209>> {});
    let (in210, in211, in212) = (CE::<CI<210>> {}, CE::<CI<211>> {}, CE::<CI<212>> {});
    let (in213, in214, in215) = (CE::<CI<213>> {}, CE::<CI<214>> {}, CE::<CI<215>> {});
    let (in216, in217, in218) = (CE::<CI<216>> {}, CE::<CI<217>> {}, CE::<CI<218>> {});
    let (in219, in220, in221) = (CE::<CI<219>> {}, CE::<CI<220>> {}, CE::<CI<221>> {});
    let (in222, in223, in224) = (CE::<CI<222>> {}, CE::<CI<223>> {}, CE::<CI<224>> {});
    let t0 = circuit_mul(in56, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t1 = circuit_add(in55, t0); // Eval sumdlogdiv_a_num Horner step: add coefficient_52
    let t2 = circuit_mul(t1, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t3 = circuit_add(in54, t2); // Eval sumdlogdiv_a_num Horner step: add coefficient_51
    let t4 = circuit_mul(t3, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t5 = circuit_add(in53, t4); // Eval sumdlogdiv_a_num Horner step: add coefficient_50
    let t6 = circuit_mul(t5, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t7 = circuit_add(in52, t6); // Eval sumdlogdiv_a_num Horner step: add coefficient_49
    let t8 = circuit_mul(t7, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t9 = circuit_add(in51, t8); // Eval sumdlogdiv_a_num Horner step: add coefficient_48
    let t10 = circuit_mul(t9, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t11 = circuit_add(in50, t10); // Eval sumdlogdiv_a_num Horner step: add coefficient_47
    let t12 = circuit_mul(t11, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t13 = circuit_add(in49, t12); // Eval sumdlogdiv_a_num Horner step: add coefficient_46
    let t14 = circuit_mul(t13, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t15 = circuit_add(in48, t14); // Eval sumdlogdiv_a_num Horner step: add coefficient_45
    let t16 = circuit_mul(t15, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t17 = circuit_add(in47, t16); // Eval sumdlogdiv_a_num Horner step: add coefficient_44
    let t18 = circuit_mul(t17, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t19 = circuit_add(in46, t18); // Eval sumdlogdiv_a_num Horner step: add coefficient_43
    let t20 = circuit_mul(t19, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t21 = circuit_add(in45, t20); // Eval sumdlogdiv_a_num Horner step: add coefficient_42
    let t22 = circuit_mul(t21, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t23 = circuit_add(in44, t22); // Eval sumdlogdiv_a_num Horner step: add coefficient_41
    let t24 = circuit_mul(t23, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t25 = circuit_add(in43, t24); // Eval sumdlogdiv_a_num Horner step: add coefficient_40
    let t26 = circuit_mul(t25, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t27 = circuit_add(in42, t26); // Eval sumdlogdiv_a_num Horner step: add coefficient_39
    let t28 = circuit_mul(t27, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t29 = circuit_add(in41, t28); // Eval sumdlogdiv_a_num Horner step: add coefficient_38
    let t30 = circuit_mul(t29, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t31 = circuit_add(in40, t30); // Eval sumdlogdiv_a_num Horner step: add coefficient_37
    let t32 = circuit_mul(t31, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t33 = circuit_add(in39, t32); // Eval sumdlogdiv_a_num Horner step: add coefficient_36
    let t34 = circuit_mul(t33, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t35 = circuit_add(in38, t34); // Eval sumdlogdiv_a_num Horner step: add coefficient_35
    let t36 = circuit_mul(t35, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t37 = circuit_add(in37, t36); // Eval sumdlogdiv_a_num Horner step: add coefficient_34
    let t38 = circuit_mul(t37, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t39 = circuit_add(in36, t38); // Eval sumdlogdiv_a_num Horner step: add coefficient_33
    let t40 = circuit_mul(t39, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t41 = circuit_add(in35, t40); // Eval sumdlogdiv_a_num Horner step: add coefficient_32
    let t42 = circuit_mul(t41, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t43 = circuit_add(in34, t42); // Eval sumdlogdiv_a_num Horner step: add coefficient_31
    let t44 = circuit_mul(t43, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t45 = circuit_add(in33, t44); // Eval sumdlogdiv_a_num Horner step: add coefficient_30
    let t46 = circuit_mul(t45, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t47 = circuit_add(in32, t46); // Eval sumdlogdiv_a_num Horner step: add coefficient_29
    let t48 = circuit_mul(t47, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t49 = circuit_add(in31, t48); // Eval sumdlogdiv_a_num Horner step: add coefficient_28
    let t50 = circuit_mul(t49, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t51 = circuit_add(in30, t50); // Eval sumdlogdiv_a_num Horner step: add coefficient_27
    let t52 = circuit_mul(t51, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t53 = circuit_add(in29, t52); // Eval sumdlogdiv_a_num Horner step: add coefficient_26
    let t54 = circuit_mul(t53, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t55 = circuit_add(in28, t54); // Eval sumdlogdiv_a_num Horner step: add coefficient_25
    let t56 = circuit_mul(t55, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t57 = circuit_add(in27, t56); // Eval sumdlogdiv_a_num Horner step: add coefficient_24
    let t58 = circuit_mul(t57, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t59 = circuit_add(in26, t58); // Eval sumdlogdiv_a_num Horner step: add coefficient_23
    let t60 = circuit_mul(t59, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t61 = circuit_add(in25, t60); // Eval sumdlogdiv_a_num Horner step: add coefficient_22
    let t62 = circuit_mul(t61, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t63 = circuit_add(in24, t62); // Eval sumdlogdiv_a_num Horner step: add coefficient_21
    let t64 = circuit_mul(t63, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t65 = circuit_add(in23, t64); // Eval sumdlogdiv_a_num Horner step: add coefficient_20
    let t66 = circuit_mul(t65, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t67 = circuit_add(in22, t66); // Eval sumdlogdiv_a_num Horner step: add coefficient_19
    let t68 = circuit_mul(t67, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t69 = circuit_add(in21, t68); // Eval sumdlogdiv_a_num Horner step: add coefficient_18
    let t70 = circuit_mul(t69, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t71 = circuit_add(in20, t70); // Eval sumdlogdiv_a_num Horner step: add coefficient_17
    let t72 = circuit_mul(t71, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t73 = circuit_add(in19, t72); // Eval sumdlogdiv_a_num Horner step: add coefficient_16
    let t74 = circuit_mul(t73, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t75 = circuit_add(in18, t74); // Eval sumdlogdiv_a_num Horner step: add coefficient_15
    let t76 = circuit_mul(t75, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t77 = circuit_add(in17, t76); // Eval sumdlogdiv_a_num Horner step: add coefficient_14
    let t78 = circuit_mul(t77, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t79 = circuit_add(in16, t78); // Eval sumdlogdiv_a_num Horner step: add coefficient_13
    let t80 = circuit_mul(t79, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t81 = circuit_add(in15, t80); // Eval sumdlogdiv_a_num Horner step: add coefficient_12
    let t82 = circuit_mul(t81, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t83 = circuit_add(in14, t82); // Eval sumdlogdiv_a_num Horner step: add coefficient_11
    let t84 = circuit_mul(t83, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t85 = circuit_add(in13, t84); // Eval sumdlogdiv_a_num Horner step: add coefficient_10
    let t86 = circuit_mul(t85, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t87 = circuit_add(in12, t86); // Eval sumdlogdiv_a_num Horner step: add coefficient_9
    let t88 = circuit_mul(t87, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t89 = circuit_add(in11, t88); // Eval sumdlogdiv_a_num Horner step: add coefficient_8
    let t90 = circuit_mul(t89, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t91 = circuit_add(in10, t90); // Eval sumdlogdiv_a_num Horner step: add coefficient_7
    let t92 = circuit_mul(t91, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t93 = circuit_add(in9, t92); // Eval sumdlogdiv_a_num Horner step: add coefficient_6
    let t94 = circuit_mul(t93, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t95 = circuit_add(in8, t94); // Eval sumdlogdiv_a_num Horner step: add coefficient_5
    let t96 = circuit_mul(t95, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t97 = circuit_add(in7, t96); // Eval sumdlogdiv_a_num Horner step: add coefficient_4
    let t98 = circuit_mul(t97, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t99 = circuit_add(in6, t98); // Eval sumdlogdiv_a_num Horner step: add coefficient_3
    let t100 = circuit_mul(t99, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t101 = circuit_add(in5, t100); // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    let t102 = circuit_mul(t101, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t103 = circuit_add(in4, t102); // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    let t104 = circuit_mul(t103, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t105 = circuit_add(in3, t104); // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    let t106 = circuit_mul(in111, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t107 = circuit_add(in110, t106); // Eval sumdlogdiv_a_den Horner step: add coefficient_53
    let t108 = circuit_mul(t107, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t109 = circuit_add(in109, t108); // Eval sumdlogdiv_a_den Horner step: add coefficient_52
    let t110 = circuit_mul(t109, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t111 = circuit_add(in108, t110); // Eval sumdlogdiv_a_den Horner step: add coefficient_51
    let t112 = circuit_mul(t111, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t113 = circuit_add(in107, t112); // Eval sumdlogdiv_a_den Horner step: add coefficient_50
    let t114 = circuit_mul(t113, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t115 = circuit_add(in106, t114); // Eval sumdlogdiv_a_den Horner step: add coefficient_49
    let t116 = circuit_mul(t115, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t117 = circuit_add(in105, t116); // Eval sumdlogdiv_a_den Horner step: add coefficient_48
    let t118 = circuit_mul(t117, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t119 = circuit_add(in104, t118); // Eval sumdlogdiv_a_den Horner step: add coefficient_47
    let t120 = circuit_mul(t119, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t121 = circuit_add(in103, t120); // Eval sumdlogdiv_a_den Horner step: add coefficient_46
    let t122 = circuit_mul(t121, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t123 = circuit_add(in102, t122); // Eval sumdlogdiv_a_den Horner step: add coefficient_45
    let t124 = circuit_mul(t123, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t125 = circuit_add(in101, t124); // Eval sumdlogdiv_a_den Horner step: add coefficient_44
    let t126 = circuit_mul(t125, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t127 = circuit_add(in100, t126); // Eval sumdlogdiv_a_den Horner step: add coefficient_43
    let t128 = circuit_mul(t127, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t129 = circuit_add(in99, t128); // Eval sumdlogdiv_a_den Horner step: add coefficient_42
    let t130 = circuit_mul(t129, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t131 = circuit_add(in98, t130); // Eval sumdlogdiv_a_den Horner step: add coefficient_41
    let t132 = circuit_mul(t131, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t133 = circuit_add(in97, t132); // Eval sumdlogdiv_a_den Horner step: add coefficient_40
    let t134 = circuit_mul(t133, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t135 = circuit_add(in96, t134); // Eval sumdlogdiv_a_den Horner step: add coefficient_39
    let t136 = circuit_mul(t135, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t137 = circuit_add(in95, t136); // Eval sumdlogdiv_a_den Horner step: add coefficient_38
    let t138 = circuit_mul(t137, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t139 = circuit_add(in94, t138); // Eval sumdlogdiv_a_den Horner step: add coefficient_37
    let t140 = circuit_mul(t139, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t141 = circuit_add(in93, t140); // Eval sumdlogdiv_a_den Horner step: add coefficient_36
    let t142 = circuit_mul(t141, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t143 = circuit_add(in92, t142); // Eval sumdlogdiv_a_den Horner step: add coefficient_35
    let t144 = circuit_mul(t143, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t145 = circuit_add(in91, t144); // Eval sumdlogdiv_a_den Horner step: add coefficient_34
    let t146 = circuit_mul(t145, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t147 = circuit_add(in90, t146); // Eval sumdlogdiv_a_den Horner step: add coefficient_33
    let t148 = circuit_mul(t147, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t149 = circuit_add(in89, t148); // Eval sumdlogdiv_a_den Horner step: add coefficient_32
    let t150 = circuit_mul(t149, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t151 = circuit_add(in88, t150); // Eval sumdlogdiv_a_den Horner step: add coefficient_31
    let t152 = circuit_mul(t151, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t153 = circuit_add(in87, t152); // Eval sumdlogdiv_a_den Horner step: add coefficient_30
    let t154 = circuit_mul(t153, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t155 = circuit_add(in86, t154); // Eval sumdlogdiv_a_den Horner step: add coefficient_29
    let t156 = circuit_mul(t155, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t157 = circuit_add(in85, t156); // Eval sumdlogdiv_a_den Horner step: add coefficient_28
    let t158 = circuit_mul(t157, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t159 = circuit_add(in84, t158); // Eval sumdlogdiv_a_den Horner step: add coefficient_27
    let t160 = circuit_mul(t159, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t161 = circuit_add(in83, t160); // Eval sumdlogdiv_a_den Horner step: add coefficient_26
    let t162 = circuit_mul(t161, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t163 = circuit_add(in82, t162); // Eval sumdlogdiv_a_den Horner step: add coefficient_25
    let t164 = circuit_mul(t163, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t165 = circuit_add(in81, t164); // Eval sumdlogdiv_a_den Horner step: add coefficient_24
    let t166 = circuit_mul(t165, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t167 = circuit_add(in80, t166); // Eval sumdlogdiv_a_den Horner step: add coefficient_23
    let t168 = circuit_mul(t167, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t169 = circuit_add(in79, t168); // Eval sumdlogdiv_a_den Horner step: add coefficient_22
    let t170 = circuit_mul(t169, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t171 = circuit_add(in78, t170); // Eval sumdlogdiv_a_den Horner step: add coefficient_21
    let t172 = circuit_mul(t171, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t173 = circuit_add(in77, t172); // Eval sumdlogdiv_a_den Horner step: add coefficient_20
    let t174 = circuit_mul(t173, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t175 = circuit_add(in76, t174); // Eval sumdlogdiv_a_den Horner step: add coefficient_19
    let t176 = circuit_mul(t175, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t177 = circuit_add(in75, t176); // Eval sumdlogdiv_a_den Horner step: add coefficient_18
    let t178 = circuit_mul(t177, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t179 = circuit_add(in74, t178); // Eval sumdlogdiv_a_den Horner step: add coefficient_17
    let t180 = circuit_mul(t179, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t181 = circuit_add(in73, t180); // Eval sumdlogdiv_a_den Horner step: add coefficient_16
    let t182 = circuit_mul(t181, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t183 = circuit_add(in72, t182); // Eval sumdlogdiv_a_den Horner step: add coefficient_15
    let t184 = circuit_mul(t183, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t185 = circuit_add(in71, t184); // Eval sumdlogdiv_a_den Horner step: add coefficient_14
    let t186 = circuit_mul(t185, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t187 = circuit_add(in70, t186); // Eval sumdlogdiv_a_den Horner step: add coefficient_13
    let t188 = circuit_mul(t187, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t189 = circuit_add(in69, t188); // Eval sumdlogdiv_a_den Horner step: add coefficient_12
    let t190 = circuit_mul(t189, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t191 = circuit_add(in68, t190); // Eval sumdlogdiv_a_den Horner step: add coefficient_11
    let t192 = circuit_mul(t191, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t193 = circuit_add(in67, t192); // Eval sumdlogdiv_a_den Horner step: add coefficient_10
    let t194 = circuit_mul(t193, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t195 = circuit_add(in66, t194); // Eval sumdlogdiv_a_den Horner step: add coefficient_9
    let t196 = circuit_mul(t195, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t197 = circuit_add(in65, t196); // Eval sumdlogdiv_a_den Horner step: add coefficient_8
    let t198 = circuit_mul(t197, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t199 = circuit_add(in64, t198); // Eval sumdlogdiv_a_den Horner step: add coefficient_7
    let t200 = circuit_mul(t199, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t201 = circuit_add(in63, t200); // Eval sumdlogdiv_a_den Horner step: add coefficient_6
    let t202 = circuit_mul(t201, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t203 = circuit_add(in62, t202); // Eval sumdlogdiv_a_den Horner step: add coefficient_5
    let t204 = circuit_mul(t203, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t205 = circuit_add(in61, t204); // Eval sumdlogdiv_a_den Horner step: add coefficient_4
    let t206 = circuit_mul(t205, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t207 = circuit_add(in60, t206); // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    let t208 = circuit_mul(t207, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t209 = circuit_add(in59, t208); // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    let t210 = circuit_mul(t209, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t211 = circuit_add(in58, t210); // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    let t212 = circuit_mul(t211, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t213 = circuit_add(in57, t212); // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    let t214 = circuit_inverse(t213);
    let t215 = circuit_mul(t105, t214);
    let t216 = circuit_mul(in166, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t217 = circuit_add(in165, t216); // Eval sumdlogdiv_b_num Horner step: add coefficient_53
    let t218 = circuit_mul(t217, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t219 = circuit_add(in164, t218); // Eval sumdlogdiv_b_num Horner step: add coefficient_52
    let t220 = circuit_mul(t219, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t221 = circuit_add(in163, t220); // Eval sumdlogdiv_b_num Horner step: add coefficient_51
    let t222 = circuit_mul(t221, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t223 = circuit_add(in162, t222); // Eval sumdlogdiv_b_num Horner step: add coefficient_50
    let t224 = circuit_mul(t223, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t225 = circuit_add(in161, t224); // Eval sumdlogdiv_b_num Horner step: add coefficient_49
    let t226 = circuit_mul(t225, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t227 = circuit_add(in160, t226); // Eval sumdlogdiv_b_num Horner step: add coefficient_48
    let t228 = circuit_mul(t227, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t229 = circuit_add(in159, t228); // Eval sumdlogdiv_b_num Horner step: add coefficient_47
    let t230 = circuit_mul(t229, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t231 = circuit_add(in158, t230); // Eval sumdlogdiv_b_num Horner step: add coefficient_46
    let t232 = circuit_mul(t231, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t233 = circuit_add(in157, t232); // Eval sumdlogdiv_b_num Horner step: add coefficient_45
    let t234 = circuit_mul(t233, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t235 = circuit_add(in156, t234); // Eval sumdlogdiv_b_num Horner step: add coefficient_44
    let t236 = circuit_mul(t235, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t237 = circuit_add(in155, t236); // Eval sumdlogdiv_b_num Horner step: add coefficient_43
    let t238 = circuit_mul(t237, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t239 = circuit_add(in154, t238); // Eval sumdlogdiv_b_num Horner step: add coefficient_42
    let t240 = circuit_mul(t239, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t241 = circuit_add(in153, t240); // Eval sumdlogdiv_b_num Horner step: add coefficient_41
    let t242 = circuit_mul(t241, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t243 = circuit_add(in152, t242); // Eval sumdlogdiv_b_num Horner step: add coefficient_40
    let t244 = circuit_mul(t243, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t245 = circuit_add(in151, t244); // Eval sumdlogdiv_b_num Horner step: add coefficient_39
    let t246 = circuit_mul(t245, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t247 = circuit_add(in150, t246); // Eval sumdlogdiv_b_num Horner step: add coefficient_38
    let t248 = circuit_mul(t247, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t249 = circuit_add(in149, t248); // Eval sumdlogdiv_b_num Horner step: add coefficient_37
    let t250 = circuit_mul(t249, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t251 = circuit_add(in148, t250); // Eval sumdlogdiv_b_num Horner step: add coefficient_36
    let t252 = circuit_mul(t251, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t253 = circuit_add(in147, t252); // Eval sumdlogdiv_b_num Horner step: add coefficient_35
    let t254 = circuit_mul(t253, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t255 = circuit_add(in146, t254); // Eval sumdlogdiv_b_num Horner step: add coefficient_34
    let t256 = circuit_mul(t255, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t257 = circuit_add(in145, t256); // Eval sumdlogdiv_b_num Horner step: add coefficient_33
    let t258 = circuit_mul(t257, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t259 = circuit_add(in144, t258); // Eval sumdlogdiv_b_num Horner step: add coefficient_32
    let t260 = circuit_mul(t259, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t261 = circuit_add(in143, t260); // Eval sumdlogdiv_b_num Horner step: add coefficient_31
    let t262 = circuit_mul(t261, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t263 = circuit_add(in142, t262); // Eval sumdlogdiv_b_num Horner step: add coefficient_30
    let t264 = circuit_mul(t263, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t265 = circuit_add(in141, t264); // Eval sumdlogdiv_b_num Horner step: add coefficient_29
    let t266 = circuit_mul(t265, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t267 = circuit_add(in140, t266); // Eval sumdlogdiv_b_num Horner step: add coefficient_28
    let t268 = circuit_mul(t267, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t269 = circuit_add(in139, t268); // Eval sumdlogdiv_b_num Horner step: add coefficient_27
    let t270 = circuit_mul(t269, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t271 = circuit_add(in138, t270); // Eval sumdlogdiv_b_num Horner step: add coefficient_26
    let t272 = circuit_mul(t271, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t273 = circuit_add(in137, t272); // Eval sumdlogdiv_b_num Horner step: add coefficient_25
    let t274 = circuit_mul(t273, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t275 = circuit_add(in136, t274); // Eval sumdlogdiv_b_num Horner step: add coefficient_24
    let t276 = circuit_mul(t275, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t277 = circuit_add(in135, t276); // Eval sumdlogdiv_b_num Horner step: add coefficient_23
    let t278 = circuit_mul(t277, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t279 = circuit_add(in134, t278); // Eval sumdlogdiv_b_num Horner step: add coefficient_22
    let t280 = circuit_mul(t279, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t281 = circuit_add(in133, t280); // Eval sumdlogdiv_b_num Horner step: add coefficient_21
    let t282 = circuit_mul(t281, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t283 = circuit_add(in132, t282); // Eval sumdlogdiv_b_num Horner step: add coefficient_20
    let t284 = circuit_mul(t283, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t285 = circuit_add(in131, t284); // Eval sumdlogdiv_b_num Horner step: add coefficient_19
    let t286 = circuit_mul(t285, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t287 = circuit_add(in130, t286); // Eval sumdlogdiv_b_num Horner step: add coefficient_18
    let t288 = circuit_mul(t287, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t289 = circuit_add(in129, t288); // Eval sumdlogdiv_b_num Horner step: add coefficient_17
    let t290 = circuit_mul(t289, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t291 = circuit_add(in128, t290); // Eval sumdlogdiv_b_num Horner step: add coefficient_16
    let t292 = circuit_mul(t291, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t293 = circuit_add(in127, t292); // Eval sumdlogdiv_b_num Horner step: add coefficient_15
    let t294 = circuit_mul(t293, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t295 = circuit_add(in126, t294); // Eval sumdlogdiv_b_num Horner step: add coefficient_14
    let t296 = circuit_mul(t295, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t297 = circuit_add(in125, t296); // Eval sumdlogdiv_b_num Horner step: add coefficient_13
    let t298 = circuit_mul(t297, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t299 = circuit_add(in124, t298); // Eval sumdlogdiv_b_num Horner step: add coefficient_12
    let t300 = circuit_mul(t299, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t301 = circuit_add(in123, t300); // Eval sumdlogdiv_b_num Horner step: add coefficient_11
    let t302 = circuit_mul(t301, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t303 = circuit_add(in122, t302); // Eval sumdlogdiv_b_num Horner step: add coefficient_10
    let t304 = circuit_mul(t303, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t305 = circuit_add(in121, t304); // Eval sumdlogdiv_b_num Horner step: add coefficient_9
    let t306 = circuit_mul(t305, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t307 = circuit_add(in120, t306); // Eval sumdlogdiv_b_num Horner step: add coefficient_8
    let t308 = circuit_mul(t307, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t309 = circuit_add(in119, t308); // Eval sumdlogdiv_b_num Horner step: add coefficient_7
    let t310 = circuit_mul(t309, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t311 = circuit_add(in118, t310); // Eval sumdlogdiv_b_num Horner step: add coefficient_6
    let t312 = circuit_mul(t311, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t313 = circuit_add(in117, t312); // Eval sumdlogdiv_b_num Horner step: add coefficient_5
    let t314 = circuit_mul(t313, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t315 = circuit_add(in116, t314); // Eval sumdlogdiv_b_num Horner step: add coefficient_4
    let t316 = circuit_mul(t315, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t317 = circuit_add(in115, t316); // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    let t318 = circuit_mul(t317, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t319 = circuit_add(in114, t318); // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    let t320 = circuit_mul(t319, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t321 = circuit_add(in113, t320); // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    let t322 = circuit_mul(t321, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t323 = circuit_add(in112, t322); // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    let t324 = circuit_mul(in224, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t325 = circuit_add(in223, t324); // Eval sumdlogdiv_b_den Horner step: add coefficient_56
    let t326 = circuit_mul(t325, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t327 = circuit_add(in222, t326); // Eval sumdlogdiv_b_den Horner step: add coefficient_55
    let t328 = circuit_mul(t327, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t329 = circuit_add(in221, t328); // Eval sumdlogdiv_b_den Horner step: add coefficient_54
    let t330 = circuit_mul(t329, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t331 = circuit_add(in220, t330); // Eval sumdlogdiv_b_den Horner step: add coefficient_53
    let t332 = circuit_mul(t331, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t333 = circuit_add(in219, t332); // Eval sumdlogdiv_b_den Horner step: add coefficient_52
    let t334 = circuit_mul(t333, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t335 = circuit_add(in218, t334); // Eval sumdlogdiv_b_den Horner step: add coefficient_51
    let t336 = circuit_mul(t335, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t337 = circuit_add(in217, t336); // Eval sumdlogdiv_b_den Horner step: add coefficient_50
    let t338 = circuit_mul(t337, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t339 = circuit_add(in216, t338); // Eval sumdlogdiv_b_den Horner step: add coefficient_49
    let t340 = circuit_mul(t339, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t341 = circuit_add(in215, t340); // Eval sumdlogdiv_b_den Horner step: add coefficient_48
    let t342 = circuit_mul(t341, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t343 = circuit_add(in214, t342); // Eval sumdlogdiv_b_den Horner step: add coefficient_47
    let t344 = circuit_mul(t343, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t345 = circuit_add(in213, t344); // Eval sumdlogdiv_b_den Horner step: add coefficient_46
    let t346 = circuit_mul(t345, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t347 = circuit_add(in212, t346); // Eval sumdlogdiv_b_den Horner step: add coefficient_45
    let t348 = circuit_mul(t347, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t349 = circuit_add(in211, t348); // Eval sumdlogdiv_b_den Horner step: add coefficient_44
    let t350 = circuit_mul(t349, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t351 = circuit_add(in210, t350); // Eval sumdlogdiv_b_den Horner step: add coefficient_43
    let t352 = circuit_mul(t351, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t353 = circuit_add(in209, t352); // Eval sumdlogdiv_b_den Horner step: add coefficient_42
    let t354 = circuit_mul(t353, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t355 = circuit_add(in208, t354); // Eval sumdlogdiv_b_den Horner step: add coefficient_41
    let t356 = circuit_mul(t355, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t357 = circuit_add(in207, t356); // Eval sumdlogdiv_b_den Horner step: add coefficient_40
    let t358 = circuit_mul(t357, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t359 = circuit_add(in206, t358); // Eval sumdlogdiv_b_den Horner step: add coefficient_39
    let t360 = circuit_mul(t359, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t361 = circuit_add(in205, t360); // Eval sumdlogdiv_b_den Horner step: add coefficient_38
    let t362 = circuit_mul(t361, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t363 = circuit_add(in204, t362); // Eval sumdlogdiv_b_den Horner step: add coefficient_37
    let t364 = circuit_mul(t363, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t365 = circuit_add(in203, t364); // Eval sumdlogdiv_b_den Horner step: add coefficient_36
    let t366 = circuit_mul(t365, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t367 = circuit_add(in202, t366); // Eval sumdlogdiv_b_den Horner step: add coefficient_35
    let t368 = circuit_mul(t367, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t369 = circuit_add(in201, t368); // Eval sumdlogdiv_b_den Horner step: add coefficient_34
    let t370 = circuit_mul(t369, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t371 = circuit_add(in200, t370); // Eval sumdlogdiv_b_den Horner step: add coefficient_33
    let t372 = circuit_mul(t371, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t373 = circuit_add(in199, t372); // Eval sumdlogdiv_b_den Horner step: add coefficient_32
    let t374 = circuit_mul(t373, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t375 = circuit_add(in198, t374); // Eval sumdlogdiv_b_den Horner step: add coefficient_31
    let t376 = circuit_mul(t375, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t377 = circuit_add(in197, t376); // Eval sumdlogdiv_b_den Horner step: add coefficient_30
    let t378 = circuit_mul(t377, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t379 = circuit_add(in196, t378); // Eval sumdlogdiv_b_den Horner step: add coefficient_29
    let t380 = circuit_mul(t379, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t381 = circuit_add(in195, t380); // Eval sumdlogdiv_b_den Horner step: add coefficient_28
    let t382 = circuit_mul(t381, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t383 = circuit_add(in194, t382); // Eval sumdlogdiv_b_den Horner step: add coefficient_27
    let t384 = circuit_mul(t383, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t385 = circuit_add(in193, t384); // Eval sumdlogdiv_b_den Horner step: add coefficient_26
    let t386 = circuit_mul(t385, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t387 = circuit_add(in192, t386); // Eval sumdlogdiv_b_den Horner step: add coefficient_25
    let t388 = circuit_mul(t387, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t389 = circuit_add(in191, t388); // Eval sumdlogdiv_b_den Horner step: add coefficient_24
    let t390 = circuit_mul(t389, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t391 = circuit_add(in190, t390); // Eval sumdlogdiv_b_den Horner step: add coefficient_23
    let t392 = circuit_mul(t391, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t393 = circuit_add(in189, t392); // Eval sumdlogdiv_b_den Horner step: add coefficient_22
    let t394 = circuit_mul(t393, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t395 = circuit_add(in188, t394); // Eval sumdlogdiv_b_den Horner step: add coefficient_21
    let t396 = circuit_mul(t395, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t397 = circuit_add(in187, t396); // Eval sumdlogdiv_b_den Horner step: add coefficient_20
    let t398 = circuit_mul(t397, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t399 = circuit_add(in186, t398); // Eval sumdlogdiv_b_den Horner step: add coefficient_19
    let t400 = circuit_mul(t399, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t401 = circuit_add(in185, t400); // Eval sumdlogdiv_b_den Horner step: add coefficient_18
    let t402 = circuit_mul(t401, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t403 = circuit_add(in184, t402); // Eval sumdlogdiv_b_den Horner step: add coefficient_17
    let t404 = circuit_mul(t403, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t405 = circuit_add(in183, t404); // Eval sumdlogdiv_b_den Horner step: add coefficient_16
    let t406 = circuit_mul(t405, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t407 = circuit_add(in182, t406); // Eval sumdlogdiv_b_den Horner step: add coefficient_15
    let t408 = circuit_mul(t407, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t409 = circuit_add(in181, t408); // Eval sumdlogdiv_b_den Horner step: add coefficient_14
    let t410 = circuit_mul(t409, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t411 = circuit_add(in180, t410); // Eval sumdlogdiv_b_den Horner step: add coefficient_13
    let t412 = circuit_mul(t411, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t413 = circuit_add(in179, t412); // Eval sumdlogdiv_b_den Horner step: add coefficient_12
    let t414 = circuit_mul(t413, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t415 = circuit_add(in178, t414); // Eval sumdlogdiv_b_den Horner step: add coefficient_11
    let t416 = circuit_mul(t415, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t417 = circuit_add(in177, t416); // Eval sumdlogdiv_b_den Horner step: add coefficient_10
    let t418 = circuit_mul(t417, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t419 = circuit_add(in176, t418); // Eval sumdlogdiv_b_den Horner step: add coefficient_9
    let t420 = circuit_mul(t419, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t421 = circuit_add(in175, t420); // Eval sumdlogdiv_b_den Horner step: add coefficient_8
    let t422 = circuit_mul(t421, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t423 = circuit_add(in174, t422); // Eval sumdlogdiv_b_den Horner step: add coefficient_7
    let t424 = circuit_mul(t423, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t425 = circuit_add(in173, t424); // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    let t426 = circuit_mul(t425, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t427 = circuit_add(in172, t426); // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    let t428 = circuit_mul(t427, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t429 = circuit_add(in171, t428); // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    let t430 = circuit_mul(t429, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t431 = circuit_add(in170, t430); // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    let t432 = circuit_mul(t431, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t433 = circuit_add(in169, t432); // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    let t434 = circuit_mul(t433, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t435 = circuit_add(in168, t434); // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    let t436 = circuit_mul(t435, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t437 = circuit_add(in167, t436); // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    let t438 = circuit_inverse(t437);
    let t439 = circuit_mul(t323, t438);
    let t440 = circuit_mul(in1, t439);
    let t441 = circuit_add(t215, t440);
    let t442 = circuit_mul(in2, t441);

    let modulus = get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (t442,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(A.x); // in0
    circuit_inputs = circuit_inputs.next_2(A.y); // in1
    circuit_inputs = circuit_inputs.next_2(coeff); // in2

    for val in SumDlogDivBatched.a_num {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.a_den {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.b_num {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.b_den {
        circuit_inputs = circuit_inputs.next_2(*val);
    }
    // in3 - in224

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: u384 = outputs.get_output(t442);
    return (res,);
}

impl CircuitDefinition50<
    E0,
    E1,
    E2,
    E3,
    E4,
    E5,
    E6,
    E7,
    E8,
    E9,
    E10,
    E11,
    E12,
    E13,
    E14,
    E15,
    E16,
    E17,
    E18,
    E19,
    E20,
    E21,
    E22,
    E23,
    E24,
    E25,
    E26,
    E27,
    E28,
    E29,
    E30,
    E31,
    E32,
    E33,
    E34,
    E35,
    E36,
    E37,
    E38,
    E39,
    E40,
    E41,
    E42,
    E43,
    E44,
    E45,
    E46,
    E47,
    E48,
    E49,
> of core::circuit::CircuitDefinition<
    (
        CE<E0>,
        CE<E1>,
        CE<E2>,
        CE<E3>,
        CE<E4>,
        CE<E5>,
        CE<E6>,
        CE<E7>,
        CE<E8>,
        CE<E9>,
        CE<E10>,
        CE<E11>,
        CE<E12>,
        CE<E13>,
        CE<E14>,
        CE<E15>,
        CE<E16>,
        CE<E17>,
        CE<E18>,
        CE<E19>,
        CE<E20>,
        CE<E21>,
        CE<E22>,
        CE<E23>,
        CE<E24>,
        CE<E25>,
        CE<E26>,
        CE<E27>,
        CE<E28>,
        CE<E29>,
        CE<E30>,
        CE<E31>,
        CE<E32>,
        CE<E33>,
        CE<E34>,
        CE<E35>,
        CE<E36>,
        CE<E37>,
        CE<E38>,
        CE<E39>,
        CE<E40>,
        CE<E41>,
        CE<E42>,
        CE<E43>,
        CE<E44>,
        CE<E45>,
        CE<E46>,
        CE<E47>,
        CE<E48>,
        CE<E49>,
    ),
> {
    type CircuitType =
        core::circuit::Circuit<
            (
                E0,
                E1,
                E2,
                E3,
                E4,
                E5,
                E6,
                E7,
                E8,
                E9,
                E10,
                E11,
                E12,
                E13,
                E14,
                E15,
                E16,
                E17,
                E18,
                E19,
                E20,
                E21,
                E22,
                E23,
                E24,
                E25,
                E26,
                E27,
                E28,
                E29,
                E30,
                E31,
                E32,
                E33,
                E34,
                E35,
                E36,
                E37,
                E38,
                E39,
                E40,
                E41,
                E42,
                E43,
                E44,
                E45,
                E46,
                E47,
                E48,
                E49,
            ),
        >;
}
impl MyDrp_50<
    E0,
    E1,
    E2,
    E3,
    E4,
    E5,
    E6,
    E7,
    E8,
    E9,
    E10,
    E11,
    E12,
    E13,
    E14,
    E15,
    E16,
    E17,
    E18,
    E19,
    E20,
    E21,
    E22,
    E23,
    E24,
    E25,
    E26,
    E27,
    E28,
    E29,
    E30,
    E31,
    E32,
    E33,
    E34,
    E35,
    E36,
    E37,
    E38,
    E39,
    E40,
    E41,
    E42,
    E43,
    E44,
    E45,
    E46,
    E47,
    E48,
    E49,
> of Drop<
    (
        CE<E0>,
        CE<E1>,
        CE<E2>,
        CE<E3>,
        CE<E4>,
        CE<E5>,
        CE<E6>,
        CE<E7>,
        CE<E8>,
        CE<E9>,
        CE<E10>,
        CE<E11>,
        CE<E12>,
        CE<E13>,
        CE<E14>,
        CE<E15>,
        CE<E16>,
        CE<E17>,
        CE<E18>,
        CE<E19>,
        CE<E20>,
        CE<E21>,
        CE<E22>,
        CE<E23>,
        CE<E24>,
        CE<E25>,
        CE<E26>,
        CE<E27>,
        CE<E28>,
        CE<E29>,
        CE<E30>,
        CE<E31>,
        CE<E32>,
        CE<E33>,
        CE<E34>,
        CE<E35>,
        CE<E36>,
        CE<E37>,
        CE<E38>,
        CE<E39>,
        CE<E40>,
        CE<E41>,
        CE<E42>,
        CE<E43>,
        CE<E44>,
        CE<E45>,
        CE<E46>,
        CE<E47>,
        CE<E48>,
        CE<E49>,
    ),
>;

