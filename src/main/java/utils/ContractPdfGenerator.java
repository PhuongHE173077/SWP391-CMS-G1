package utils;

import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.FontFactory;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Utility class để tạo PDF cho hợp đồng
 */
public class ContractPdfGenerator {

    /**
     * Tạo PDF hợp đồng và trả về bytes
     * 
     * @param contractId      ID hợp đồng
     * @param customerName    Tên khách hàng
     * @param customerEmail   Email khách hàng
     * @param customerPhone   SĐT khách hàng
     * @param customerAddress Địa chỉ khách hàng
     * @param creatorName     Tên người tạo hợp đồng
     * @param content         Nội dung hợp đồng
     * @param devices         Danh sách thiết bị (mỗi item là mảng: [tên thiết bị,
     *                        serial, thời gian bảo trì])
     * @return byte array của file PDF
     */
    public static byte[] generateContractPdf(
            int contractId,
            String customerName,
            String customerEmail,
            String customerPhone,
            String customerAddress,
            String creatorName,
            String content,
            List<String[]> devices) {

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        Document document = new Document(PageSize.A4, 50, 50, 50, 50);

        try {
            PdfWriter.getInstance(document, baos);
            document.open();

            // Fonts
            Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, Color.DARK_GRAY);
            Font headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, Color.BLACK);
            Font normalFont = FontFactory.getFont(FontFactory.HELVETICA, 11, Color.BLACK);
            Font smallFont = FontFactory.getFont(FontFactory.HELVETICA, 10, Color.GRAY);

            // Title
            Paragraph title = new Paragraph("HOP DONG DICH VU", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(10);
            document.add(title);

            // Contract ID
            Paragraph contractIdPara = new Paragraph("Ma hop dong: #" + contractId, smallFont);
            contractIdPara.setAlignment(Element.ALIGN_CENTER);
            contractIdPara.setSpacingAfter(20);
            document.add(contractIdPara);

            // Date
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
            Paragraph datePara = new Paragraph("Ngay tao: " + sdf.format(new Date()), smallFont);
            datePara.setAlignment(Element.ALIGN_RIGHT);
            datePara.setSpacingAfter(20);
            document.add(datePara);

            // Customer Info Section
            Paragraph customerHeader = new Paragraph("THONG TIN KHACH HANG", headerFont);
            customerHeader.setSpacingBefore(10);
            customerHeader.setSpacingAfter(10);
            document.add(customerHeader);

            PdfPTable customerTable = new PdfPTable(2);
            customerTable.setWidthPercentage(100);
            customerTable.setWidths(new float[] { 1, 2 });

            addTableRow(customerTable, "Ho va ten:", customerName != null ? customerName : "N/A", normalFont);
            addTableRow(customerTable, "Email:", customerEmail != null ? customerEmail : "N/A", normalFont);
            addTableRow(customerTable, "So dien thoai:", customerPhone != null ? customerPhone : "N/A", normalFont);
            addTableRow(customerTable, "Dia chi:", customerAddress != null ? customerAddress : "N/A", normalFont);

            document.add(customerTable);

            // Contract Content Section
            Paragraph contentHeader = new Paragraph("NOI DUNG HOP DONG", headerFont);
            contentHeader.setSpacingBefore(20);
            contentHeader.setSpacingAfter(10);
            document.add(contentHeader);

            Paragraph contentPara = new Paragraph(content != null ? content : "Khong co noi dung", normalFont);
            contentPara.setSpacingAfter(20);
            document.add(contentPara);

            // Devices Section
            if (devices != null && !devices.isEmpty()) {
                Paragraph devicesHeader = new Paragraph("DANH SACH THIET BI", headerFont);
                devicesHeader.setSpacingBefore(10);
                devicesHeader.setSpacingAfter(10);
                document.add(devicesHeader);

                PdfPTable deviceTable = new PdfPTable(4);
                deviceTable.setWidthPercentage(100);
                deviceTable.setWidths(new float[] { 0.5f, 2, 1.5f, 1 });

                // Header row
                Font tableHeaderFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, Color.WHITE);
                addTableHeaderCell(deviceTable, "STT", tableHeaderFont);
                addTableHeaderCell(deviceTable, "Ten thiet bi", tableHeaderFont);
                addTableHeaderCell(deviceTable, "So Serial", tableHeaderFont);
                addTableHeaderCell(deviceTable, "Bao tri (thang)", tableHeaderFont);

                // Data rows
                int index = 1;
                for (String[] device : devices) {
                    PdfPCell cell1 = new PdfPCell(new Phrase(String.valueOf(index++), normalFont));
                    cell1.setHorizontalAlignment(Element.ALIGN_CENTER);
                    cell1.setPadding(5);
                    deviceTable.addCell(cell1);

                    PdfPCell cell2 = new PdfPCell(new Phrase(device[0], normalFont));
                    cell2.setPadding(5);
                    deviceTable.addCell(cell2);

                    PdfPCell cell3 = new PdfPCell(new Phrase(device[1], normalFont));
                    cell3.setPadding(5);
                    deviceTable.addCell(cell3);

                    PdfPCell cell4 = new PdfPCell(new Phrase(device[2], normalFont));
                    cell4.setHorizontalAlignment(Element.ALIGN_CENTER);
                    cell4.setPadding(5);
                    deviceTable.addCell(cell4);
                }

                document.add(deviceTable);
            }

            // Signature Section
            Paragraph signatureHeader = new Paragraph("CHU KY", headerFont);
            signatureHeader.setSpacingBefore(40);
            signatureHeader.setSpacingAfter(10);
            document.add(signatureHeader);

            PdfPTable signatureTable = new PdfPTable(2);
            signatureTable.setWidthPercentage(100);

            PdfPCell customerSignCell = new PdfPCell();
            customerSignCell.setBorder(0);
            customerSignCell.addElement(new Paragraph("Khach hang", headerFont));
            customerSignCell.addElement(new Paragraph("\n\n\n"));
            customerSignCell
                    .addElement(new Paragraph(customerName != null ? customerName : "_______________", normalFont));
            customerSignCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            signatureTable.addCell(customerSignCell);

            PdfPCell companySignCell = new PdfPCell();
            companySignCell.setBorder(0);
            companySignCell.addElement(new Paragraph("Dai dien cong ty", headerFont));
            companySignCell.addElement(new Paragraph("\n\n\n"));
            companySignCell
                    .addElement(new Paragraph(creatorName != null ? creatorName : "_______________", normalFont));
            companySignCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            signatureTable.addCell(companySignCell);

            document.add(signatureTable);

            document.close();

        } catch (DocumentException e) {
            e.printStackTrace();
            return null;
        }

        return baos.toByteArray();
    }

    private static void addTableRow(PdfPTable table, String label, String value, Font font) {
        PdfPCell labelCell = new PdfPCell(new Phrase(label, font));
        labelCell.setBorder(0);
        labelCell.setPadding(5);
        table.addCell(labelCell);

        PdfPCell valueCell = new PdfPCell(new Phrase(value, font));
        valueCell.setBorder(0);
        valueCell.setPadding(5);
        table.addCell(valueCell);
    }

    private static void addTableHeaderCell(PdfPTable table, String text, Font font) {
        PdfPCell cell = new PdfPCell(new Phrase(text, font));
        cell.setBackgroundColor(new Color(66, 139, 202));
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setPadding(8);
        table.addCell(cell);
    }
}
