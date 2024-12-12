import { Controller, Logger } from '@nestjs/common';
import { MessagePattern } from '@nestjs/microservices';

@Controller('health')
export class HealthController {
  private readonly logger = new Logger('HealthController');
  @MessagePattern('health')
  getHealth() {
    this.logger.log('GET /health');
    return { status: 'ok' };
  }
}
