"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.SetRoles = void 0;
const common_1 = require("@nestjs/common");
const SetRoles = (...roles) => (0, common_1.SetMetadata)('roles', roles);
exports.SetRoles = SetRoles;
//# sourceMappingURL=setRoles.decorator.js.map