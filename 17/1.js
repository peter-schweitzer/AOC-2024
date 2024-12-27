import { log } from 'node:console';
import { readFileSync } from 'node:fs';

// const [raw_init_reg, raw_prog] = readFileSync('test.txt', { encoding: 'utf8' }).split('\n\n');
const [raw_init_reg, raw_prog] = readFileSync('input.txt', { encoding: 'utf8' }).split('\n\n');

//@ts-ignore array should never be empty
const [init_reg_A, init_reg_B, init_reg_C] = raw_init_reg.split('\n').map((a) => Number.parseInt(a.split(' ').pop()));

/** @type {number[]} */
//@ts-ignore
const prog = raw_prog
  .split(' ')
  .pop()
  .split(',')
  .map((v) => Number.parseInt(v));

//#region disasm
log('regA:', init_reg_A);
log('regB:', init_reg_B);
log('regC:', init_reg_C);
/** @type {(operand: number) => string} */
function get_combo_operand_semantic(operand) {
  switch (operand) {
    case 4:
      return 'regA';
    case 5:
      return 'regB';
    case 6:
      return 'regC';
    default:
      return `${operand}`;
  }
}

for (let i = 0; i < prog.length; ) {
  const [op_code, raw_operand] = prog.slice(i, (i += 2));
  /** @type {[string, string]} */
  const [op, operand] = {
    0: ['adv', get_combo_operand_semantic(raw_operand)],
    1: ['bxl', `${raw_operand}`],
    2: ['bst', get_combo_operand_semantic(raw_operand)],
    3: ['jnz', `${raw_operand}`],
    4: ['bxc', '_'],
    5: ['out', get_combo_operand_semantic(raw_operand)],
    6: ['bdv', get_combo_operand_semantic(raw_operand)],
    7: ['cdv', get_combo_operand_semantic(raw_operand)],
  }[op_code];

  const fn = {
    0: `regA >>= ${operand}`,
    1: `regB ^= ${operand}`,
    2: `regB = ${operand} & 7`,
    3: `if(regA != 0) inst_ptr = ${operand}`,
    4: `regB ^= regC`,
    5: `std_out.push(${operand})`,
    6: `regB = regA >> ${operand}`,
    7: `regC = regA >> ${operand}`,
  }[op_code];

  log(`${op_code} ${raw_operand} -> ${op} ${operand.padStart(4, ' ')} => ${fn}`);
}
log('=====');

//#endregion disasm

/** @type {{A: number, B: number, C: number}} */
const registers = { A: init_reg_A, B: init_reg_B, C: init_reg_C };
let inst_ptr = 0;

/** @type {number[]} */
const std_out_buff = [];

/** @type {(operand: number) => number} */
function combo_operand(operand) {
  switch (operand) {
    case 4:
      return registers.A;
    case 5:
      return registers.B;
    case 6:
      return registers.C;
    default:
      return operand;
  }
}

/** @type {((operand: number)=>void)[]} */
const ops = [
  //adv
  (operand) => (registers.A >>= combo_operand(operand)),

  //bxl
  (operand) => (registers.B ^= operand),

  //bst
  (operand) => (registers.B = combo_operand(operand) & 7),

  //jnz
  (operand) => (inst_ptr = registers.A !== 0 ? operand : inst_ptr),

  //bxc
  (_) => (registers.B ^= registers.C),

  //out
  (operand) => std_out_buff.push(combo_operand(operand) & 7),

  //bdv
  (operand) => (registers.B = registers.A >> combo_operand(operand)),

  //cdv
  (operand) => (registers.C = registers.A >> combo_operand(operand)),
];

while (inst_ptr < prog.length) {
  const [op_code, operand] = prog.slice(inst_ptr, (inst_ptr += 2));
  ops[op_code](operand);
}

console.log(std_out_buff.join(','));
