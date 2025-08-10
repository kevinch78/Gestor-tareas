import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards } from '@nestjs/common';
import { TasksService } from './tasks.service';
import { CreateTaskDto } from './dto/CreateTaskDto';
import { UpdateTaskDto } from './dto/UpdateTaskDto';
import { AuthGuard } from '@nestjs/passport';
import { CurrentUser } from '../common/decorator/user.decorator';

@UseGuards(AuthGuard('jwt'))
@Controller('tasks')
export class TasksController {
  constructor(private tasksService: TasksService) {}

  @Get()
  getAll(@CurrentUser() user: any) {
    return this.tasksService.findAll(user.userId);
  }

  @Post()
  create(@CurrentUser() user: any, @Body() dto: CreateTaskDto) {
    return this.tasksService.create(dto, user.userId);
  }

  @Get(':id')
  getOne(@Param('id') id: string, @CurrentUser() user: any) {
    return this.tasksService.findOne(id, user.userId);
  }

  @Patch(':id')
  update(@Param('id') id: string, @CurrentUser() user: any, @Body() dto: UpdateTaskDto) {
    return this.tasksService.update(id, user.userId, dto);
  }

  @Delete(':id')
  remove(@Param('id') id: string, @CurrentUser() user: any) {
    return this.tasksService.remove(id, user.userId);
  }
}
