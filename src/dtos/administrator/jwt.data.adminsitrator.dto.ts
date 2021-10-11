export class JwtDataAdministratorDto{
    adminstratorId: number;
    username: string;
    ext: number; //Unix timestamp
    ip: string;
    ua: string;

    toPlainObject() {
        return {
            administartorId: this.adminstratorId,
            username: this.username,
            ext: this.ext,
            ip: this.ip,
            ua: this.ua
        }
    }
}