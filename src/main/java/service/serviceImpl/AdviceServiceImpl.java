package service.serviceImpl;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

import java.util.ArrayList;
import java.util.List;
import lombok.RequiredArgsConstructor;
import model.device;
import service.iService.IDeviceService;

/**
 *
 * @author admin
 */

@RequiredArgsConstructor
public class AdviceServiceImpl implements IDeviceService{
        
    @Override
    public List<device>getAllDevices(){
        
        return new ArrayList<>();
    }
    
}
