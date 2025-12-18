package model;

/**
 * Model để lưu thông tin thiết bị bán chạy
 */
public class TopDevice {
    private int deviceId;
    private String deviceName;
    private String deviceImage;
    private int totalSold; // Tổng số seri đã được làm hợp đồng

    public TopDevice() {
    }

    public TopDevice(int deviceId, String deviceName, String deviceImage, int totalSold) {
        this.deviceId = deviceId;
        this.deviceName = deviceName;
        this.deviceImage = deviceImage;
        this.totalSold = totalSold;
    }

    public int getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(int deviceId) {
        this.deviceId = deviceId;
    }

    public String getDeviceName() {
        return deviceName;
    }

    public void setDeviceName(String deviceName) {
        this.deviceName = deviceName;
    }

    public String getDeviceImage() {
        return deviceImage;
    }

    public void setDeviceImage(String deviceImage) {
        this.deviceImage = deviceImage;
    }

    public int getTotalSold() {
        return totalSold;
    }

    public void setTotalSold(int totalSold) {
        this.totalSold = totalSold;
    }
}
