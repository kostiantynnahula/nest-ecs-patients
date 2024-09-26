import { Injectable } from '@nestjs/common';
import { CreatePatientDto } from './dto/create-patient.dto';
import { UpdatePatientDto } from './dto/update-patient.dto';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class PatientsService {
  constructor(private prisma: PrismaService) {}

  async create(createPatientDto: CreatePatientDto) {
    return await this.prisma.patient.create({ data: createPatientDto });
  }

  async findAll() {
    return await this.prisma.patient.findMany();
  }

  async findOne(id: string) {
    return await this.prisma.patient.findUnique({ where: { id } });
  }

  async update(id: string, updatePatientDto: UpdatePatientDto) {
    return await this.prisma.patient.update({
      where: { id },
      data: updatePatientDto,
    });
  }

  async remove(id: string) {
    return await this.prisma.patient.delete({ where: { id } });
  }
}
