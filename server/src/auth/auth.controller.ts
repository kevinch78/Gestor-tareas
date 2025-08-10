import { Controller, Post, Body, HttpCode } from '@nestjs/common';
import { AuthService } from './auth.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('register')
  async register(@Body() dto: RegisterDto) {
    // crea usuario y devuelve token
    return this.authService.register(dto.email, dto.password);
  }

  @HttpCode(200)
  @Post('login')
  async login(@Body() dto: LoginDto) {
    const validated = await this.authService.validateUser(dto.email, dto.password);
    if (!validated) throw new Error('Invalid credentials'); // más abajo cambiamos por UnauthorizedException
    return this.authService.login(validated);
  }
}
