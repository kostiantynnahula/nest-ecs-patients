import {
  IsDefined,
  IsString,
  MinLength,
  MaxLength,
  IsEmail,
  IsPhoneNumber,
} from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreatePatientDto {
  @ApiProperty({ required: true, minLength: 3, maxLength: 45 })
  @IsDefined()
  @IsString()
  @MinLength(3)
  @MaxLength(45)
  name: string;

  @ApiProperty({ required: true, minLength: 3, maxLength: 45 })
  @IsDefined()
  @IsString()
  @IsEmail()
  @MinLength(3)
  @MaxLength(45)
  email: string;

  @ApiProperty({ required: true, minLength: 3, maxLength: 45 })
  @IsDefined()
  @IsString()
  @IsPhoneNumber()
  @MinLength(3)
  @MaxLength(45)
  phone: string;
}
