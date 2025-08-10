import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Task } from './task.entity';
import { CreateTaskDto } from './dto/CreateTaskDto';
import { UpdateTaskDto } from './dto/UpdateTaskDto';

@Injectable()
export class TasksService {
  constructor(@InjectRepository(Task) private repo: Repository<Task>) {}

  create(dto: CreateTaskDto, ownerId: string) {
    const task = this.repo.create({ ...dto, ownerId });
    return this.repo.save(task);
  }

  findAll(ownerId: string) {
    return this.repo.find({ where: { ownerId }, order: { createdAt: 'DESC' } });
  }

  async findOne(id: string, ownerId: string) {
    const task = await this.repo.findOne({ where: { id, ownerId } });
    if (!task) throw new NotFoundException('Task not found');
    return task;
  }

  async update(id: string, ownerId: string, dto: UpdateTaskDto) {
    const task = await this.findOne(id, ownerId);
    Object.assign(task, dto);
    return this.repo.save(task);
  }

  async remove(id: string, ownerId: string) {
    const task = await this.findOne(id, ownerId);
    await this.repo.remove(task);
    return { success: true };
  }
}
