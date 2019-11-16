"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (Object.hasOwnProperty.call(mod, k)) result[k] = mod[k];
    result["default"] = mod;
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
const core = __importStar(require("@actions/core"));
const exec = __importStar(require("@actions/exec"));
function run() {
    return __awaiter(this, void 0, void 0, function* () {
        try {
            yield exec.exec('julia', ['--color=yes', '--project=docs/', '-e', 'using Pkg; Pkg.develop(PackageSpec(path=pwd())); Pkg.instantiate()']);
            // TODO Remove this once Documenter 0.24 is tagged
            yield exec.exec('julia', ['--color=yes', '--project=docs/', '-e', 'using Pkg; Pkg.add(PackageSpec(name="Documenter", revision="master"))']);
            yield exec.exec('julia', ['--color=yes', '--project=docs/', 'docs/make.jl']);
        }
        catch (error) {
            core.setFailed(error.message);
        }
    });
}
run();
