import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Match, MatchDocument } from './match.schema';

@Injectable()
export class MatchService {
  constructor(@InjectModel(Match.name) private matchModel: Model<MatchDocument>) {}

  async findAll(): Promise<Match[]> {
    return this.matchModel.find().exec();
  }

  async create(match: Match): Promise<Match> {
    const createdMatch = new this.matchModel(match);
    return createdMatch.save();
  }
}
