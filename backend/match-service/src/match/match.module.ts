import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { MatchService } from './match.service';
import { MatchController } from './match.controller';
import { Match, MatchSchema } from './match.schema';

@Module({
  imports: [MongooseModule.forFeature([{ name: Match.name, schema: MatchSchema }])],
  controllers: [MatchController],
  providers: [MatchService],
})
export class MatchModule {}
