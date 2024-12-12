import { Controller, Get, Logger } from '@nestjs/common';

@Controller('health')
export class HealthController {
  private readonly logger = new Logger('HealthController');
  @Get()
  getHealth() {
    this.logger.log('GET /health');
    return { status: 'ok' };
  }
}
