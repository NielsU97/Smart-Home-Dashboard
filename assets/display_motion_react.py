import time
import board
import busio
import adafruit_vl53l0x
import subprocess

# Configuration
DISPLAY_THRESHOLD = 600  # mm - distance threshold to turn on display
BRIGHTNESS_ON = 255      # Full brightness when on
BRIGHTNESS_OFF = 0       # Minimum brightness when off
DEBOUNCE_TIME = 2        # seconds to prevent rapid toggling

class DisplayController:
    def __init__(self):
        self.sensor = None
        self.display_state = False
        self.last_toggle_time = 0
        
    def initialize_sensor(self):
        """Initialize the VL53L0X ToF sensor"""
        i2c = busio.I2C(board.SCL, board.SDA)
        self.sensor = adafruit_vl53l0x.VL53L0X(i2c)
    
    def set_brightness(self, brightness):
        """Set display brightness"""
        cmd = f'echo {brightness} | sudo tee /sys/class/backlight/*/brightness'
        subprocess.run(cmd, shell=True, capture_output=True)
    
    def set_display_state(self, new_state):
        """Set the display state with debouncing"""
        current_time = time.time()
        
        # Debounce rapid changes
        if current_time - self.last_toggle_time < DEBOUNCE_TIME:
            return
        
        if new_state != self.display_state:
            self.display_state = new_state
            self.last_toggle_time = current_time
            
            if new_state:
                self.set_brightness(BRIGHTNESS_ON)
            else:
                self.set_brightness(BRIGHTNESS_OFF)
    
    def read_distance(self):
        """Read distance from ToF sensor"""
        try:
            distance = self.sensor.range
            # Handle invalid readings
            if distance == 0 or distance > 2000:
                return None
            return distance
        except:
            return None
    
    def run(self):
        """Main control loop"""
        self.initialize_sensor()
        self.set_display_state(False)  # Start with display off
        
        while True:
            distance = self.read_distance()
            
            if distance is not None:
                should_be_on = distance < DISPLAY_THRESHOLD
                self.set_display_state(should_be_on)
            else:
                # No valid reading - turn display OFF
                self.set_display_state(False)
            
            time.sleep(0.5)

def main():
    controller = DisplayController()
    try:
        controller.run()
    except KeyboardInterrupt:
        # Turn display back on before exit
        cmd = f'echo {BRIGHTNESS_ON} | sudo tee /sys/class/backlight/*/brightness'
        subprocess.run(cmd, shell=True, capture_output=True)

if __name__ == "__main__":
    main()
