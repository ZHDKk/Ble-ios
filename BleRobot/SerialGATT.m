//
//  SerialGATT.m
//  BLKApp
//
//

#import "SerialGATT.h"

@implementation SerialGATT

@synthesize delegate;
@synthesize peripherals;
@synthesize manager;
@synthesize activePeripheral;

/*!
 *  @method swap:
 *
 *  @param s Uint16 value to byteswap
 *
 *  @discussion swap byteswaps a UInt16
 *
 *  @return Byteswapped UInt16
 */

-(UInt16) swap:(UInt16)s {
    UInt16 temp = s << 8;
    temp |= (s >> 8);
    return temp;
}

/*
 * (void) setup
 * 启用CoreBluetooth CentralManager并设置SerialGATT的委托
 *
 */

-(void) setup
{
    manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    str = @"";
}

/*
 * -(int) findBLKAppPeripherals:(int)timeout
 *
 */
-(int) findBLKAppPeripherals:(int)timeout
{
    if ([manager state] != CBCentralManagerStatePoweredOn) {
        printf("CoreBluetooth is not correctly initialized !\n");
        return -1;
    }
    
    [NSTimer scheduledTimerWithTimeInterval:(float)timeout target:self selector:@selector(scanTimer:) userInfo:nil repeats:NO];
    
    //[manager scanForPeripheralsWithServices:[NSArray arrayWithObject:serviceUUID] options:0]; // start Scanning
    [manager scanForPeripheralsWithServices:nil options:0];
    return 0;
}

/*
 * scanTimer
 * when findBLKAppPeripherals is timeout, this function will be called
 *
 */
-(void) scanTimer:(NSTimer *)timer
{
    [manager stopScan];
}

/*
 *  @method printPeripheralInfo:
 *
 *  @param peripheral Peripheral to print info of
 *
 *  @discussion printPeripheralInfo prints detailed info about peripheral
 *
 */
- (void) printPeripheralInfo:(CBPeripheral*)peripheral {
    CFStringRef s = CFUUIDCreateString(NULL, (__bridge CFUUIDRef )peripheral.identifier);
    printf("------------------------------------\r\n");
    printf("Peripheral Info :\r\n");
    printf("UUID : %s\r\n",CFStringGetCStringPtr(s, 0));
    printf("RSSI : %d\r\n",[peripheral.RSSI intValue]);
    printf("Name : %s\r\n",[peripheral.name cStringUsingEncoding:NSStringEncodingConversionAllowLossy]);
    printf("isConnected : %d\r\n",peripheral.state == CBPeripheralStateConnected);
    printf("-------------------------------------\r\n");
    
}

/*
 * connect
 * 连接到给定的外设
 *
 */
-(void) connect:(CBPeripheral *)peripheral
{
    if (!(peripheral.state == CBPeripheralStateConnected)) {
        [manager connectPeripheral:peripheral options:nil];
    }
}

/*
 * disconnect
 * 断开给定的外设
 *
 */
-(void) disconnect:(CBPeripheral *)peripheral
{
    [manager cancelPeripheralConnection:peripheral];
}


#pragma mark - basic operations for SerialGATT service
-(void) write:(CBPeripheral *)peripheral value:(NSString *)value
{
    [self writeValue:SERVICE_UUID characteristicUUID:WRITE_UUID p:peripheral value:value];
    str=@"";
}

-(void)changeName:(CBPeripheral *)peripheral value:(NSString *)value
{
    [self writeValue:SERVICE_UUID characteristicUUID:NAME_UUID p:peripheral value:value];
}

-(void) read:(CBPeripheral *)peripheral
{
    printf("begin reading\n");
    //[peripheral readValueForCharacteristic:dataRecvrCharacteristic];
    printf("now can reading......\n");
}

-(void) notify: (CBPeripheral *)peripheral on:(BOOL)on
{
    [self notification:SERVICE_UUID characteristicUUID:READ_UUID p:peripheral on:YES];
}


#pragma mark - CBCentralManager Delegates

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    //TODO: to handle the state updates
}

//连接外设
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    printf("Now we found device\n");
    if (!peripherals) {
        peripherals = [[NSMutableArray alloc] initWithObjects:peripheral, nil];
        for (int i = 0; i < [peripherals count]; i++) {
            [delegate peripheralFound: peripheral];
        }
    }
    
    {
        if((__bridge CFUUIDRef )peripheral.identifier == NULL) return;
        //if(peripheral.name == NULL) return;
        //if(peripheral.name == nil) return;
        if(peripheral.name.length < 1) return;
        // Add the new peripheral to the peripherals array
        for (int i = 0; i < [peripherals count]; i++) {
            CBPeripheral *p = [peripherals objectAtIndex:i];
            if((__bridge CFUUIDRef )p.identifier == NULL) continue;
            CFUUIDBytes b1 = CFUUIDGetUUIDBytes((__bridge CFUUIDRef )p.identifier);
            CFUUIDBytes b2 = CFUUIDGetUUIDBytes((__bridge CFUUIDRef )peripheral.identifier);
            if (memcmp(&b1, &b2, 16) == 0) {
                // these are the same, and replace the old peripheral information
                [peripherals replaceObjectAtIndex:i withObject:peripheral];
                printf("Duplicated peripheral is found...\n");
                //[delegate peripheralFound: peripheral];
                return;
            }
        }
        printf("New peripheral is found...\n");
        [peripherals addObject:peripheral];
        [delegate peripheralFound:peripheral];
        return;
    }
    printf("%s\n", __FUNCTION__);
}


//扫描外设中的服务和特征
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    activePeripheral = peripheral;
    activePeripheral.delegate = self;
    
    [activePeripheral discoverServices:nil];
    //[self notify:peripheral on:YES];
    
    [self printPeripheralInfo:peripheral];
    
    printf("connected to the active peripheral\n");
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    printf("disconnected to the active peripheral\n");
    if(activePeripheral != nil)
        [delegate setDisconnect];
    //1 activePeripheral = nil;
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"连接失败 %@: %@\n", [peripheral name], [error localizedDescription]);
}

#pragma mark - CBPeripheral delegates

//读取数据
//获取的charateristic的值
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    printf("in updateValueForCharacteristic function\n");
    
    if (error) {
        printf("updateValueForCharacteristic failed\n");
        return;
    }
    //打印出characteristic的UUID和值
//    NSLog(@"特征 uuid:%@  获取到的值:%@",characteristic.UUID,characteristic.value);
   
    
    NSData *data = characteristic.value;
    NSLog(@"返回的值:%@",data);
     value = [self hexadecimalString:data];
    NSLog(@"转化后的值:%@",value);
    if ((value.length<40) && (value.length>=10)
        &&([[value substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"0002"]
//        ||[[value substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"0003"]
        ||[[value substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"0004"]
        ||[[value substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"0005"]
        ||[[value substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"0006"]
        ||[[value substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"0007"]
        ||[[value substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"0008"]
        ||[[value substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"0009"]
        ||[[value substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"000A"]
        ||[[value substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"000B"]
        ||[[value substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"000C"]
        ||[[value substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"000E"]
        ||[[value substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"000F"]
        ||[[value substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"0011"]
        ||[[value substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"0012"]
        ||[[value substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"0014"]
        ||[[value substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"001A"]
        ||[[value substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"001B"]
        ||[[value substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"001C"]
        ||[[value substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"001D"]
        ||[[value substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"001E"]
        ||[[value substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"001F"]
        ||[[value substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"0020"]
        ||[[value substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"0021"]
        ||[[value substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"0022"]
        ||[[value substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"0023"]
        ||[[value substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"0024"]
        ||[[value substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"0025"])) {
        self.callBackBlock(value);
    }else{
        str = [str stringByAppendingString:value];
        NSLog(@"拼接后的值:%@",str);
        self.callBackBlock(str);
//        thread = [[NSThread alloc]initWithTarget:self selector:@selector(appendData) object:nil];
//        [thread start];
    }
    }
    
-(void)appendData
{
        str = [str stringByAppendingString:value];
        NSLog(@"拼接后的值:%@",str);
        self.callBackBlock(str);
    
}
    
   
    
//    [delegate serialGATTCharValueUpdated:@"ff02" value:characteristic.value];
    
    

//将传入的NSData类型转换成NSString并返回
- (NSString*)hexadecimalString:(NSData *)data{
    NSString* result;
    const unsigned char* dataBuffer = (const unsigned char*)[data bytes];
    if(!dataBuffer){
        return nil;
    }
    NSUInteger dataLength = [data length];
    NSMutableString* hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for(int i = 0; i < dataLength; i++){
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    }
    result = [NSString stringWithString:hexString];
    return result;
}

//////////////////////////////////////////////////////////////////////////////////////////////

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    
}

/*
 *  @method getAllCharacteristicsFromKeyfob
 *
 *  @param p Peripheral to scan
 *
 *
 *  @discussion getAllCharacteristicsFromKeyfob starts a characteristics discovery on a peripheral
 *  pointed to by p
 *
 */
-(void) getAllCharacteristicsFromKeyfob:(CBPeripheral *)p{
    for (int i=0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
        printf("Fetching characteristics for service with UUID : %s\r\n",[self CBUUIDToString:s.UUID]);
        //扫描到每个service的characteristics
        [p discoverCharacteristics:nil forService:s];
    }
}

/*
 *  @method didDiscoverServices
 *
 *  @param peripheral Pheripheral that got updated
 *  @error error Error message if something went wrong
 *
 *  @discussion didDiscoverServices is called when CoreBluetooth has discovered services on a
 *  peripheral after the discoverServices routine has been called on the peripheral
 *
 */

//发现服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (!error) {
        printf("Services of peripheral with UUID : %s found\r\n",[self UUIDToString:(__bridge CFUUIDRef )peripheral.identifier]);
        [self getAllCharacteristicsFromKeyfob:peripheral];
    }
    else {
        printf("Service discovery was unsuccessfull !\r\n");
    }
}

/*
 *  @method didDiscoverCharacteristicsForService
 *
 *  @param peripheral Pheripheral that got updated
 *  @param service Service that characteristics where found on
 *  @error error Error message if something went wrong
 *
 *  @discussion didDiscoverCharacteristicsForService is called when CoreBluetooth has discovered
 *  characteristics on a service, on a peripheral after the discoverCharacteristics routine has been called on the service
 *
 */

//发现服务中的特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (!error) {
        printf("Characteristics of service with UUID : %s found\r\n",[self CBUUIDToString:service.UUID]);
        for(int i = 0; i < service.characteristics.count; i++) { //Show every one
            CBCharacteristic *c = [service.characteristics objectAtIndex:i];
            self.activeCharacteristic = c;
            [self.activePeripheral setNotifyValue:YES forCharacteristic:c];
            printf("Found characteristic %s\r\n",[ self CBUUIDToString:c.UUID]);
        }
      
       
        [delegate setConnect];

    }
    else {
        printf("Characteristic discorvery unsuccessfull !\r\n");
    }
}

//搜索到Characteristic的Descriptors
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    //打印出Characteristic和他的Descriptors
    NSLog(@"characteristic uuid:%@",characteristic.UUID);
    for (CBDescriptor *d in characteristic.descriptors) {
        NSLog(@"Descriptor uuid:%@",d.UUID);
    }
    
}
//获取到Descriptors的值
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error{
    //打印出DescriptorsUUID 和value
    //这个descriptor都是对于characteristic的描述，一般都是字符串，所以这里我们转换成字符串去解析
    NSLog(@"characteristic uuid:%@  value:%@",[NSString stringWithFormat:@"%@",descriptor.UUID],descriptor.value);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (!error) {
        printf("Updated notification state for characteristic with UUID %s on service with  UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:characteristic.UUID],[self CBUUIDToString:characteristic.service.UUID],[self UUIDToString:(__bridge CFUUIDRef )peripheral.identifier]);
//        [delegate setConnect];
    }
    else {
        printf("Error in setting notification state for characteristic with UUID %s on service with  UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:characteristic.UUID],[self CBUUIDToString:characteristic.service.UUID],[self UUIDToString:(__bridge CFUUIDRef )peripheral.identifier]);
        printf("Error code was %s\r\n",[[error description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy]);
    }
}

/*
 *  @method CBUUIDToString
 *
 *  @param UUID UUID to convert to string
 *
 *  @returns Pointer to a character buffer containing UUID in string representation
 *
 *  @discussion CBUUIDToString converts the data of a CBUUID class to a character pointer for easy printout using printf()
 *
 */
-(const char *) CBUUIDToString:(CBUUID *) UUID {
    return [[UUID.data description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
}


/*
 *  @method UUIDToString
 *
 *  @param UUID UUID to convert to string
 *
 *  @returns Pointer to a character buffer containing UUID in string representation
 *
 *  @discussion UUIDToString converts the data of a CFUUIDRef class to a character pointer for easy printout using printf()
 *
 */
-(const char *) UUIDToString:(CFUUIDRef)UUID {
    if (!UUID) return "NULL";
    CFStringRef s = CFUUIDCreateString(NULL, UUID);
    return CFStringGetCStringPtr(s, 0);
    
}

/*
 *  @method compareCBUUID
 *
 *  @param UUID1 UUID 1 to compare
 *  @param UUID2 UUID 2 to compare
 *
 *  @returns 1 (equal) 0 (not equal)
 *
 *  @discussion compareCBUUID compares two CBUUID's to each other and returns 1 if they are equal and 0 if they are not
 *
 */

-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2 {
    char b1[16];
    char b2[16];
    [UUID1.data getBytes:b1];
    [UUID2.data getBytes:b2];
    if (memcmp(b1, b2, UUID1.data.length) == 0)return 1;
    else return 0;
}


/*
 *  @method findServiceFromUUID:
 *
 *  @param UUID CBUUID to find in service list
 *  @param p Peripheral to find service on
 *
 *  @return pointer to CBService if found, nil if not
 *
 *  @discussion findServiceFromUUID searches through the services list of a peripheral to find a
 *  service with a specific UUID
 *
 */
-(CBService *) findServiceFromUUIDEx:(CBUUID *)UUID p:(CBPeripheral *)p {
    for(int i = 0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
        if ([self compareCBUUID:s.UUID UUID2:UUID]) return s;
    }
    return nil; //Service not found on this peripheral
}

/*
 *  @method findCharacteristicFromUUID:
 *
 *  @param UUID CBUUID to find in Characteristic list of service
 *  @param service Pointer to CBService to search for charateristics on
 *
 *  @return pointer to CBCharacteristic if found, nil if not
 *
 *  @discussion findCharacteristicFromUUID searches through the characteristic list of a given service
 *  to find a characteristic with a specific UUID
 *
 */
-(CBCharacteristic *) findCharacteristicFromUUIDEx:(CBUUID *)UUID service:(CBService*)service {
    for(int i=0; i < service.characteristics.count; i++) {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        if ([self compareCBUUID:c.UUID UUID2:UUID]) return c;
    }
    return nil; //Characteristic not found on this service
}


/*!
 *  @method notification:
 *
 *  @param serviceUUID Service UUID to read from (e.g. 0x2400)
 *  @param characteristicUUID Characteristic UUID to read from (e.g. 0x2401)
 *  @param p CBPeripheral to read from
 *
 *  @discussion Main routine for enabling and disabling notification services. It converts integers
 *  into CBUUID's used by CoreBluetooth. It then searches through the peripherals services to find a
 *  suitable service, it then checks that there is a suitable characteristic on this service.
 *  If this is found, the notfication is set.
 *
 */
-(void) notification:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p on:(BOOL)on {
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUIDEx:su p:p];
    if (!service) {
        printf("Could not find service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:su],[self UUIDToString:(__bridge CFUUIDRef )p.identifier]);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUIDEx:cu service:service];
    if (!characteristic) {
        printf("Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],[self UUIDToString:(__bridge CFUUIDRef )p.identifier]);
        return;
    }
    [p setNotifyValue:on forCharacteristic:characteristic];
}


/*!
 *  @method writeValue:
 *
 *  @param serviceUUID Service UUID to write to (e.g. 0x2400)
 *  @param characteristicUUID Characteristic UUID to write to (e.g. 0x2401)
 *  @param data Data to write to peripheral
 *  @param p CBPeripheral to write to
 *
 *  @discussion Main routine for writeValue request, writes without feedback. It converts integer into
 *  CBUUID's used by CoreBluetooth. It then searches through the peripherals services to find a
 *  suitable service, it then checks that there is a suitable characteristic on this service.
 *  If this is found, value is written. If not nothing is done.
 *
 */

-(void) writeValue:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p value:(NSString *)value{
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUIDEx:su p:p];
    if (!service) {
        printf("Could not find service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:su],[self UUIDToString:(__bridge CFUUIDRef )p.identifier]);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUIDEx:cu service:service];
    if (!characteristic) {
        printf("Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],[self UUIDToString:(__bridge CFUUIDRef )p.identifier]);
        return;
    }
      NSData *data = [self stringToByte:value];
    for (int i=0; i<[data length]; i+=20) {
        if ((i+20)<[data length]) {
            NSString *rangeStr = [NSString stringWithFormat:@"%i,%i", i, 20];
            NSData *subData = [data subdataWithRange:NSRangeFromString(rangeStr)];
            if(characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse)
            {
                [p writeValue:subData forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
            }else
            {
                [p writeValue:subData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
            }
            //根据接收模块的处理能力做相应延时
            usleep(20 * 1000);
        }else{
            NSString *rangeStr = [NSString stringWithFormat:@"%i,%i", i, (int)([data length] - i)];
            NSData *subData = [data subdataWithRange:NSRangeFromString(rangeStr)];
            if(characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse)
            {
                [p writeValue:subData forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
            }else
            {
                [p writeValue:subData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
            }
            //根据接收模块的处理能力做相应延时
            usleep(20 * 1000);
        }
    }
    
}


-(NSData *)stringToByte:(NSString*)string{
    NSString *hexString=[[string uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([hexString length]%2!=0) {
        return nil;
    }
    Byte tempbyt[1]={0};
    NSMutableData* bytes=[NSMutableData data];
    for(int i=0;i<[hexString length];i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            return nil;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            return nil;
        
        tempbyt[0] = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
        [bytes appendBytes:tempbyt length:1];
    }
    return bytes;
}
    

/*!
 *  @method readValue:
 *
 *  @param serviceUUID Service UUID to read from (e.g. 0x2400)
 *  @param characteristicUUID Characteristic UUID to read from (e.g. 0x2401)
 *  @param p CBPeripheral to read from
 *
 *  @discussion Main routine for read value request. It converts integers into
 *  CBUUID's used by CoreBluetooth. It then searches through the peripherals services to find a
 *  suitable service, it then checks that there is a suitable characteristic on this service.
 *  If this is found, the read value is started. When value is read the didUpdateValueForCharacteristic
 *  routine is called.
 *
 *  @see didUpdateValueForCharacteristic
 */

-(void) readValue: (int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p {
    printf("In read Value");
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUIDEx:su p:p];
    if (!service) {
        printf("Could not find service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:su],[self UUIDToString:(__bridge CFUUIDRef )p.identifier]);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUIDEx:cu service:service];
    if (!characteristic) {
        printf("Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],[self UUIDToString:(__bridge CFUUIDRef )p.identifier]);
        return;
    }
    [p readValueForCharacteristic:characteristic];
}

@end
