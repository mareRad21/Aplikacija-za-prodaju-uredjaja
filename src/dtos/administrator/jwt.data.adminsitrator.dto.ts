export class JwtDataAdministratorDto{
    adminstratorId: number;
    username: string;
    exp: number; //Unix timestamp
    ip: string;
    ua: string;

    toPlainObject() {
        return {
            administartorId: this.adminstratorId,
            username: this.username,
            exp: this.exp,
            ip: this.ip,
            ua: this.ua
        }
    }
}