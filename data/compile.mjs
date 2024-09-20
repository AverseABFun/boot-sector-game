import { fileURLToPath } from 'url';
import { dirname } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

import { readFileSync, writeFileSync } from "fs";
import { join } from "path";

var file = JSON.parse(readFileSync(join(__dirname, "text.json")).toString("utf-8"));

var out = `\
; Automatically generated from data/text.json; DO NOT EDIT!

bits 16

%ifndef GEN_TEXT_S
%define GEN_TEXT_S

%define _TEXTC(name, text) \\
    name: db text, 0

`

for (const name of Object.keys(file)) {
    out += `_TEXTC(${name},"${file[name]}")\n`
}

out = out.trim()

out += `

%endif`

writeFileSync(join(__dirname, "..", "src", "generated", "text.s"), out)