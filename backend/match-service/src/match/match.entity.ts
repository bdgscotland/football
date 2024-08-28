import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity()
export class Match {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  homeTeam: string;

  @Column()
  awayTeam: string;

  @Column()
  date: string;

  @Column()
  time: string;

  @Column()
  stadium: string;
}
