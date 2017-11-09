//
//  SerialGATT.h
//  BLKApp
//
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define SERVICE_UUID     0xFF12
#define WRITE_UUID        0xFF01
#define READ_UUID        0xFF02
#define NAME_UUID        0xFF06
#define IMME_ALERT_UUID  0x180A


@protocol BTSmartSensorDelegate

@optional
- (void) peripheralFound:(CBPeripheral *)peripheral;
- (void) serialGATTCharValueUpdated: (NSString *)UUID value: (NSData *)data;
- (void) setConnect;
- (void) setDisconnect;
@end

@interface SerialGATT : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate>{
    NSString *strData;
    NSThread *thread;
    NSString *value;
    NSString *str;

}

@property (nonatomic, assign) id <BTSmartSensorDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *peripherals;
@property (strong, nonatomic) CBCentralManager *manager;
@property (strong, nonatomic) CBPeripheral *activePeripheral;
@property(strong,nonatomic) CBCharacteristic *activeCharacteristic;

#pragma mark - Methods for controlling the BLKApp Sensor
-(void) setup; //controller setup

-(int) findBLKAppPeripherals:(int)timeout;
-(void) scanTimer: (NSTimer *)timer;

-(void) connect: (CBPeripheral *)peripheral;
-(void) disconnect: (CBPeripheral *)peripheral;

-(void) write:(CBPeripheral *)peripheral value:(NSString *)value;
-(void) read:(CBPeripheral *)peripheral;
-(void) notify:(CBPeripheral *)peripheral on:(BOOL)on;
-(void)changeName:(CBPeripheral *)peripheral value:(NSString *)value;


- (void) printPeripheralInfo:(CBPeripheral*)peripheral;

-(void) notification:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p on:(BOOL)on;
-(UInt16) swap:(UInt16)s;

-(CBService *) findServiceFromUUIDEx:(CBUUID *)UUID p:(CBPeripheral *)p;
-(CBCharacteristic *) findCharacteristicFromUUIDEx:(CBUUID *)UUID service:(CBService*)service;
-(void) writeValue:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p value:(NSString *)value;
-(void) readValue: (int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p;

typedef void(^CallBackBlcok) (NSString *text);

@property (nonatomic,copy)CallBackBlcok callBackBlock;;
@end
