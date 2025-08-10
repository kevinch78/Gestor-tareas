import { Injectable } from '@nestjs/common';
import { UsersService } from '../users/users.service';
import * as bcrypt from 'bcrypt';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class AuthService {
  constructor(private usersService: UsersService, private jwtService: JwtService) {}

  async validateUser(email: string, password: string) {
    const user = await this.usersService.findByEmail(email);
    if (!user) return null;
    const valid = await bcrypt.compare(password, user.password);
    if (!valid) return null;
    // quitamos password antes de devolver
    const { password: _p, ...result } = user as any;
    return result;
  }

  async login(user: any) {
    const payload = { sub: user.id, email: user.email };
    return {
      access_token: this.jwtService.sign(payload),
      expires_in: process.env.JWT_EXPIRES_IN || '3600s',
    };
  }

  async register(email: string, password: string) {
    // crea usuario y devuelve token directamente (opcional) o devuelve usuario
    const user = await this.usersService.create(email, password);
    return this.login(user);
  }
}
