import { Test, TestingModule } from '@nestjs/testing';
import { TasksService } from './tasks.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Task } from './task.entity';
import { Repository } from 'typeorm';
import { NotFoundException } from '@nestjs/common';

describe('TasksService', () => {
  let service: TasksService;
  let repo: jest.Mocked<Repository<Task>>;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        TasksService,
        {
          provide: getRepositoryToken(Task),
          useValue: {
            create: jest.fn(),
            save: jest.fn(),
            find: jest.fn(),
            findOne: jest.fn(),
            remove: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<TasksService>(TasksService);
    repo = module.get(getRepositoryToken(Task));
  });

  describe('create', () => {
    it('debe crear una nueva tarea', async () => {
      const dto = { title: 'Test', description: 'Desc' };
      const savedTask = { id: '1', ...dto, ownerId: 'user123' } as Task;

      repo.create.mockReturnValue(savedTask);
      repo.save.mockResolvedValue(savedTask);

      const result = await service.create(dto, 'user123');
      expect(repo.create).toHaveBeenCalledWith({ ...dto, ownerId: 'user123' });
      expect(result).toEqual(savedTask);
    });
  });

  describe('findAll', () => {
    it('debe retornar todas las tareas de un usuario', async () => {
      const tasks = [{ id: '1', title: 'Task 1' }] as Task[];
      repo.find.mockResolvedValue(tasks);

      const result = await service.findAll('user123');
      expect(repo.find).toHaveBeenCalledWith({
        where: { ownerId: 'user123' },
        order: { createdAt: 'DESC' },
      });
      expect(result).toEqual(tasks);
    });
  });

  describe('findOne', () => {
    it('debe retornar una tarea existente', async () => {
      const task = { id: '1', title: 'Task 1', ownerId: 'user123' } as Task;
      repo.findOne.mockResolvedValue(task);

      const result = await service.findOne('1', 'user123');
      expect(result).toEqual(task);
    });

    it('debe lanzar NotFoundException si no existe', async () => {
      repo.findOne.mockResolvedValue(null);

      await expect(service.findOne('1', 'user123')).rejects.toThrow(NotFoundException);
    });
  });

  describe('update', () => {
    it('debe actualizar una tarea existente', async () => {
      const existingTask = { id: '1', title: 'Old', ownerId: 'user123' } as Task;
      const updatedTask = { ...existingTask, title: 'New' } as Task;

      jest.spyOn(service, 'findOne').mockResolvedValue(existingTask);
      repo.save.mockResolvedValue(updatedTask);

      const result = await service.update('1', 'user123', { title: 'New' });
      expect(result.title).toBe('New');
      expect(repo.save).toHaveBeenCalledWith(updatedTask);
    });
  });

  describe('remove', () => {
    it('debe eliminar una tarea existente', async () => {
      const existingTask = { id: '1', title: 'To Delete', ownerId: 'user123' } as Task;

      jest.spyOn(service, 'findOne').mockResolvedValue(existingTask);
      repo.remove.mockResolvedValue(existingTask);

      const result = await service.remove('1', 'user123');
      expect(result).toEqual({ success: true });
      expect(repo.remove).toHaveBeenCalledWith(existingTask);
    });
  });
});
