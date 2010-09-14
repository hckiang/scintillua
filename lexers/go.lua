-- Copyright 2006-2010 Mitchell mitchell<att>caladbolg.net. See LICENSE.
-- Go LPeg lexer

local l = lexer
local token, style, color, word_match = l.token, l.style, l.color, l.word_match
local P, R, S = l.lpeg.P, l.lpeg.R, l.lpeg.S

module(...)

local ws = token('whitespace', l.space^1)

-- comments
local line_comment = '//' * l.nonnewline^0
local block_comment = '/*' * (l.any - '*/')^0 * '*/'
local comment = token('comment', line_comment + block_comment)

-- strings
local sq_str = l.delimited_range("'", '\\', true, false, '\n')
local dq_str = l.delimited_range('"', '\\', true, false, '\n')
local raw_str = l.delimited_range('`', nil, true)
local string = token('string', sq_str + dq_str)

-- numbers
local number = token('number', (l.float + l.integer) * P('i')^-1)

-- keywords
local keyword = token('keyword', word_match {
  'break', 'case', 'chan', 'const', 'continue', 'default', 'defer', 'else',
  'fallthrough', 'for', 'func', 'go', 'goto', 'if', 'import', 'interface',
  'map', 'package', 'range', 'return', 'select', 'struct', 'switch', 'type',
  'var'
})

-- constants
local constant = token('constant', word_match {
  'true', 'false', 'iota', 'nil'
})

-- types
local type = token('type', word_match {
  'bool', 'byte', 'complex64', 'complex128', 'ffloat32', 'float64', 'int8',
  'int16', 'int32', 'int64', 'string', 'uint8', 'uint16', 'uint32', 'uint64',
  'complex', 'float', 'int', 'uint', 'uintptr'
})

-- functions
local func = token('function', word_match {
  'cap', 'close', 'closed', 'cmplx', 'copy', 'imag', 'len', 'make', 'new',
  'panic', 'print', 'println', 'real'
})

-- identifiers
local identifier = token('identifier', l.word)

-- operators
local operator = token('operator', S('+-*/%&|^<>=!:;.,()[]{}'))

_rules = {
  { 'whitespace', ws },
  { 'keyword', keyword },
  { 'constant', constant },
  { 'type', type },
  { 'function', func },
  { 'identifier', identifier },
  { 'string', string },
  { 'comment', comment },
  { 'number', number },
  { 'operator', operator },
  { 'any_char', l.any_char },
}