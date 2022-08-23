#include "kipr/core/platform.hpp"
#include "kipr/core/registers.hpp"
#include "kipr/core/cleanup.hpp"

#include "kipr/log/log.hpp"

#include "device.hpp"

#include <csignal>
#include <thread>


using namespace kipr;
using namespace kipr::core;


namespace
{
  log::Log logger("core");

  void signal_handler(int s)
  {
    std::thread cleanup_thread(cleanup, true);
    cleanup_thread.detach();
  }
}

Platform *Platform::instance_ = nullptr;
std::mutex Platform::instance_mut_;

Platform::Platform()
{
  // register sig int handler
  struct sigaction sigIntHandler;
  sigIntHandler.sa_handler = signal_handler;
  sigemptyset(&sigIntHandler.sa_mask);
  sigIntHandler.sa_flags = 0;
  sigaction(SIGINT, &sigIntHandler, NULL);
  sigaction(SIGTERM, &sigIntHandler, NULL);
}

Platform::~Platform()
{
  cleanup(false);
}

Platform *Platform::instance()
{
  std::lock_guard<std::mutex> lock(instance_mut_);
  
  if (!instance_)
  {
    instance_ = new Platform();
  }

  return instance_;
}

unsigned char Platform::readRegister8b(unsigned char address)
{
  if (address >= REG_READABLE_COUNT)
  {
    logger.error() << "Address " << address << " is invalid";
    return 0;
  }

  return DEVICE->r8(address);
}

void Platform::writeRegister8b(unsigned char address, unsigned char value)
{
  if (address >= REG_ALL_COUNT)
  {
    logger.error() << "8-bit address " << address << " is invalid";
    return;
  }

  DEVICE->w8(address, value);
}

unsigned short Platform::readRegister16b(unsigned char address)
{
  if (address >= REG_READABLE_COUNT - 1)
  {
    logger.error() << "16-bit address " << address << " is invalid";
    return 0;
  }

  return DEVICE->r16(address);
}

void Platform::writeRegister16b(unsigned char address, unsigned short value)
{
  if (address >= REG_READABLE_COUNT - 1)
  {
    logger.error() << "16-bit address " << address << " is invalid";
    return;
  }

  return DEVICE->w16(address, value);
}

unsigned int Platform::readRegister32b(unsigned char address)
{
  if (address >= REG_READABLE_COUNT - 3)
  {
    logger.error() << "32-bit address " << address << " is invalid";
    return 0;
  }

  return DEVICE->r32(address);
}

void Platform::writeRegister32b(unsigned char address, unsigned int value)
{
  if (address >= REG_READABLE_COUNT - 3)
  {
    logger.error() << "32-bit address " << address << " is invalid";
    return;
  }

  return DEVICE->w32(address, value);
}
