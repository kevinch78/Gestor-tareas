import { PartialType } from '@nestjs/mapped-types';
import { CreateTaskDto } from './CreateTaskDto';
import { IsOptional, IsBoolean } from 'class-validator';

export class UpdateTaskDto extends PartialType(CreateTaskDto) {
  @IsOptional()
  @IsBoolean()
  completed?: boolean;
}
