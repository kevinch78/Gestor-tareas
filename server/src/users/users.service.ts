import { Injectable, ConflictException, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './users.entity';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UsersService {
  constructor(@InjectRepository(User) private usersRepo: Repository<User>) {}

  async create(email: string, plainPassword: string): Promise<User> {
    const existing = await this.usersRepo.findOne({ where: { email } });
    if (existing) throw new ConflictException('Email already registered');
    const salt = await bcrypt.genSalt(10);
    const password = await bcrypt.hash(plainPassword, salt);
    const user = this.usersRepo.create({ email, password });
    return this.usersRepo.save(user);
  }

  async findByEmail(email: string): Promise<User | null> {
    return this.usersRepo.findOne({ where: { email } });
  }

  async findById(id: string): Promise<User | null> {
    return this.usersRepo.findOne({ where: { id } });
  }
}
