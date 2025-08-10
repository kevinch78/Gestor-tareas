import { Test, TestingModule } from '@nestjs/testing';
import { AuthService } from './auth.service';
import { UsersService } from '../users/users.service';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';

jest.mock('bcrypt', () => ({
  compare: jest.fn((p, h) => Promise.resolve(p === h)),
}));

describe('AuthService', () => {
  let service: AuthService;
  let usersService: jest.Mocked<UsersService>;
  let jwtService: jest.Mocked<JwtService>;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        { provide: UsersService, useValue: { findByEmail: jest.fn(), create: jest.fn() } },
        { provide: JwtService, useValue: { sign: jest.fn() } },
      ],
    }).compile();

    service = module.get(AuthService);
    usersService = module.get(UsersService);
    jwtService = module.get(JwtService);
  });

  it('debe retornar null si el usuario no existe', async () => {
    usersService.findByEmail.mockResolvedValue(null);
    const result = await service.validateUser('test@example.com', 'pass');
    expect(result).toBeNull();
  });

  it('debe retornar el usuario sin password si es válido', async () => {
    const fakeUser = { id: '1', email: 'test@example.com', password: '1234' };
    usersService.findByEmail.mockResolvedValue(fakeUser);
    (bcrypt.compare as jest.Mock).mockResolvedValue(true);

    const result = await service.validateUser('test@example.com', '1234');
    expect(result).toEqual({ id: '1', email: 'test@example.com' });
  });
});
