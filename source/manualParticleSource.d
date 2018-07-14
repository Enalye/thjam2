module th.manualParticleSource;

import grimoire;

import std.random;

class ManualParticleSource: ParticleSource {
	override void update(float deltaTime) {
		foreach(Particle particle, uint index; particles) {
			particle.time += deltaTime;
			float t = particle.time / particle.timeToLive;
			if(t > 1f)
				particles.markInternalForRemoval(index);
			else {
				foreach(filter; filters) {
					filter.apply(particle, deltaTime);
				}

				particle.position += particle.velocity * deltaTime;
				particle.spriteAngle += particle.spriteAngleSpeed * deltaTime;
			}
		}

		float random(float step, float delta) {
			if(delta == 0f)
				return step;
			return uniform!"[]"((1f - delta) * step, (1f + delta) * step);
		}

		float random2(float step, float delta) {
			if(delta == 0f)
				return step;
			return uniform!"[]"(step - delta / 2f, step + delta / 2f);
		}

		particles.sweepMarkedData();
	}
}
