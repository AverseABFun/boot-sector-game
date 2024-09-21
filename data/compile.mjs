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

%macro _TEXTC 2+
    %1: db %2
%endmacro
%macro _TEXTL 2+
    %1: dw %2
%endmacro
%macro _TEXTLI 2+
    %1: dw %2
%endmacro

`

for (const name of Object.keys(file)) {
    var orig = file[name]
    file[name] = file[name].split("\n")
    var toUse = file[name]
    if (file[name].length == 1) {
        toUse = "\"" + file[name][0] + "\""
    } else {
        var out2 = "\""
        var i = 0;
        for (const item of file[name]) {
            out2 += item
            if (i != file[name].length-1) {
                out2 += "\", 0Ah, 0Dh, "
            }
            i++
        }
        out2 += "0"
        toUse = out2
    }
    out += `_TEXTC ${name},${toUse}\n`
    out += `_TEXTL ${name}_length,${orig.length + (file[name].length*2) - 2}\n`
    out += `_TEXTLI ${name}_lines,${file[name].length}\n`
}

out = out.trim()

out += `

%endif`

writeFileSync(join(__dirname, "..", "src", "generated", "text.s"), out)