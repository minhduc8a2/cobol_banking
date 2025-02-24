package cobol.example.banksystem.Services;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Date;

public class ExcelFileReader {
    XSSFWorkbook wb;
    XSSFSheet sheet;

    public ExcelFileReader(String excelPath) {
        try {
            File src = new File(excelPath);
            FileInputStream fis = new FileInputStream(src);
            wb = new XSSFWorkbook(fis);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public String getStringData(int sheetnumber, int row, int column) {
        sheet = wb.getSheetAt(sheetnumber);
        String data = sheet.getRow(row).getCell(column).getStringCellValue();
        return data;
    }

    public double getNumbmuricData(int sheetnumber, int row, int column) {
        sheet = wb.getSheetAt(sheetnumber);
        double data = sheet.getRow(row).getCell(column).getNumericCellValue();
        return data;
    }

    public int getRowCount(int sheetIndex) {
        int row = wb.getSheetAt(sheetIndex).getLastRowNum();
        row = row + 1;
        return row;
    }

    public Date getDateData(int sheetnumber, int row, int column) {
        sheet = wb.getSheetAt(sheetnumber);
        Cell cell = sheet.getRow(row).getCell(column);

        if (cell != null && cell.getCellType() == CellType.NUMERIC && DateUtil.isCellDateFormatted(cell)) {
            return cell.getDateCellValue();  // Return the date
        } else {
            throw new IllegalArgumentException("The cell does not contain a date.");
        }
    }
}