//
//  ViewController.m
//  陀螺仪
//
//  Created by Benniu15 on 15/6/25.
//  Copyright (c) 2015年 XF. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController (){
    
    CMMotionManager * manager;
    NSOperationQueue * queue;
    
    CMDeviceMotion * cmdMotion;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    manager = [[CMMotionManager alloc] init];;
    queue = [[NSOperationQueue alloc] init];
    
    // CMDeviceMotion 主要包含：
    //      1.attitude            手机在当前空间的位置和姿势
    //      2.gravity             重力信息
    //      3.userAcceleration    加速度信息
    //      4.rotationRate        旋转速率
    cmdMotion = manager.deviceMotion;
    if (manager.deviceMotionAvailable) {
        
        NSLog(@"【陀螺仪】x:%+.2f  y:%+.2f  z:%+.2f",cmdMotion.rotationRate.x,cmdMotion.rotationRate.y,cmdMotion.rotationRate.z);
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self startGyro];
//    [self startAccelerometer];
//    [self startMagnetometer];
}

//加速度
- (void)startAccelerometer{
    
    if ([manager isAccelerometerAvailable]) {
        
        [manager setAccelerometerUpdateInterval:1 / 40.0];
        [manager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            
            NSLog(@"【加速计】x:%+.2f  y:%+.2f",accelerometerData.acceleration.x,accelerometerData.acceleration.y);
        }];
    } else {
        
        NSLog(@"加速计不可用");
    }
    
    /*
     【加速计】x:-0.50  y:-0.05
     【加速计】x:-0.51  y:+0.03
     【加速计】x:-0.51  y:+0.06
     【加速计】x:-0.57  y:+0.05
     【加速计】x:-0.67  y:-0.00
     【加速计】x:-0.56  y:+0.03
     【加速计】x:-0.52  y:+0.03
     【加速计】x:-0.55  y:+0.07
     */
}

//陀螺仪
- (void)startGyro{
    
    if ([manager isGyroAvailable] == YES) {
        
        [manager setGyroUpdateInterval:1.0/10.0];
        [manager startGyroUpdatesToQueue:queue withHandler:^(CMGyroData *gyroData, NSError *error) {
            
            NSLog(@"【陀螺仪】x:%+.2f  y:%+.2f  z:%+.2f",gyroData.rotationRate.x,gyroData.rotationRate.y,gyroData.rotationRate.z);
        }];
    }else {
        
        NSLog(@"陀螺仪不可用");
    }
    
    /*
     【陀螺仪】x:-1.32  y:-0.04  z:+0.16
     【陀螺仪】x:-1.48  y:-0.02  z:+0.12
     【陀螺仪】x:-1.04  y:-0.04  z:+0.16
     【陀螺仪】x:-0.38  y:-0.41  z:+0.95
     【陀螺仪】x:+0.45  y:-0.42  z:+0.88
     【陀螺仪】x:+0.80  y:-0.14  z:+0.22
     */
}

//磁力计
- (void)startMagnetometer{
    
    if ([manager isMagnetometerAvailable] == YES) {
        
        [manager setMagnetometerUpdateInterval:1.0/10.0];
        [manager startMagnetometerUpdatesToQueue:queue withHandler:^(CMMagnetometerData * magnetometerData, NSError * error){
            
            NSLog(@"【磁力计】x:%+.2f  y:%+.2f  z:%+.2f",magnetometerData.magneticField.x, magnetometerData.magneticField.y,magnetometerData.magneticField.z);
        }];
    }else {
        
        NSLog(@"磁力计不可用");
    }
    
    /*
     【磁力计】x:+41.11  y:+228.16  z:-629.80
     【磁力计】x:+41.97  y:+227.29  z:-631.32
     【磁力计】x:+42.15  y:+228.51  z:-631.49
     【磁力计】x:+40.76  y:+228.51  z:-629.80
     【磁力计】x:+40.93  y:+228.33  z:-629.97
     【磁力计】x:+41.28  y:+227.29  z:-629.97
     【磁力计】x:+42.67  y:+227.98  z:-629.63
     */
}

- (void)motion{
    
    //1. Accelerometer 获取手机加速度数据
    //    double dx = manager.accelerometerData.acceleration.x;
    //    double dy = manager.accelerometerData.acceleration.y;
    //    double dz = manager.accelerometerData.acceleration.z;
    
    //2. Gravity 获取手机的重力值在各个方向上的分量，根据这个就可以获得手机的空间位置，倾斜角度等
    //    double gx = manager.deviceMotion.gravity.x;
    //    double gy = manager.deviceMotion.gravity.y;
    //    double gz = manager.deviceMotion.gravity.z;
    // 获取手机的倾斜角度,  zTheta是手机与水平面的夹角, xyTheta是手机绕自身旋转的角度
    //    double zTheta = atan2(gz,sqrtf(gx*gx+gy*gy))/M_PI*180.0;
    //    double xyTheta = atan2(gx,gy)/M_PI*180.0;
    //
    //3. DeviceMotion 获取陀螺仪的数据 包括角速度，空间位置等
    //旋转角速度：
    //    CMRotationRate rotationRate = manager.deviceMotion.rotationRate;
    //    double rotationX = rotationRate.x;
    //    double rotationY = rotationRate.y;
    //    double rotationZ = rotationRate.z;
    //空间位置的欧拉角（通过欧拉角可以算得手机两个时刻之间的夹角，比用角速度计算精确地多）
    //    double roll = manager.deviceMotion.attitude.roll;
    //    double pitch = manager.deviceMotion.attitude.pitch;
    //    double yaw = manager.deviceMotion.attitude.yaw;
    //空间位置的四元数（与欧拉角类似，但解决了万向结死锁问题）
    //    double w = manager.deviceMotion.attitude.quaternion.w;
    //    double wx = manager.deviceMotion.attitude.quaternion.x;
    //    double wy = manager.deviceMotion.attitude.quaternion.y;
    //    double wz = manager.deviceMotion.attitude.quaternion.z;
    
}

@end





