import { PrismaClient } from '@prisma/client';

// initialize Prisma Client
const prisma = new PrismaClient();

async function main() {
  const email = 'demo_patient@gmail.com';

  const patient = await prisma.patient.findFirst({
    where: { email },
  });

  if (!patient) {
    const result = await prisma.patient.create({
      data: {
        email,
        name: 'Demo Patient',
        phone: '+380777116621',
      },
    });
    console.log('Created patient:', result);
  }
}

// execute the main function
main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    // close Prisma Client at the end
    await prisma.$disconnect();
  });
