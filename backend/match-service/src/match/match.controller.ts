import { Controller, Get, Post, Body, UseGuards } from '@nestjs/common';
import { MatchService } from './match.service';
import { Match } from './match.schema';  // Updated to use the schema
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('matches')
export class MatchController {
  constructor(private readonly matchService: MatchService) {}

  @UseGuards(JwtAuthGuard)
  @Get()
  findAll() {
    return this.matchService.findAll();
  }

  @UseGuards(JwtAuthGuard)
  @Post()
  create(@Body() match: Match) {  // Updated to use the schema
    return this.matchService.create(match);
  }
}
